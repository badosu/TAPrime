---------------------------------------------------------------------------------------------------------------------
-- Comments: Sets all idle units that are not selected to fight. That has as effect to reclaim if there is low metal,
--	repair nearby units and assist in building if they have the possibility.
--	New: If you shift+drag a build order it will interrupt the current assist (from auto assist)
---------------------------------------------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name = "Auto Assist v2",
        desc = "Makes idle construction units and structures reclaim, repair nearby units and assist building",
        author = "MaDDoX, based on Johan Hanssen Seferidis' unit_auto_reclaim_heal_assist",
        date = "Oct 14, 2020",
        license = "GPLv3",
        layer = 0,
        enabled = true,
    }
end

VFS.Include("gamedata/taptools.lua")

local spGetAllUnits = Spring.GetAllUnits
local spGetUnitDefID = Spring.GetUnitDefID
local spGetFeatureDefID = Spring.GetFeatureDefID
local spValidFeatureID = Spring.ValidFeatureID
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitHealth   = Spring.GetUnitHealth
local spGetSelectedUnits = Spring.GetSelectedUnits
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetTeamResources = Spring.GetTeamResources
local spGetUnitTeam    = Spring.GetUnitTeam
local spGetUnitsInSphere = Spring.GetUnitsInSphere
local spGetFeaturesInSphere = Spring.GetFeaturesInSphere
local spGetGameFrame = Spring.GetGameFrame
local spGetUnitsInCylinder = Spring.GetUnitsInCylinder
local spGetUnitNearestEnemy = Spring.GetUnitNearestEnemy
local spGetFeaturePosition = Spring.GetFeaturePosition
local spGetCommandQueue = Spring.GetCommandQueue -- 0 => commandQueueSize, -1 = table
local spGetFullBuildQueue = Spring.GetFullBuildQueue

local idlingDelay = 10   -- How many frames after 'idle' the unit is actually considered idle (required to not break scripts)
local myTeamID = -1;
local idleCheckUpdateRate = 40  -- How long it'll take for an idled unit to check things around it
local automatedCheckUpdateRate = 90 -- How long it'll take for an automated unit to see if it shouldn't be doing something else
local basicBuilderAssistRadius = 250

local automatableUnits = {}
local automatedUnits = {}
local assistStoppedUnits = {}
local cancelAutoassistFor = {} -- { frame = unitID }
local guardingUnits = {}    -- TODO: Commanders guarding factories, we('ll) use it to stop guarding when we're out of resources
local orderRemovalDelay = 10    -- 10 frames of delay before removing commands, to prevent the engine from removing just given orders
local internalCommandUIDs = {}
local autoassistEnableDelay = 60


-- We use this to identify units that can't be build-assisted by basic builders
local WIPmobileUnits = {}     -- { unitID = true, ... }
local unitsToAutomate = {}
local automatedUnits = {}

local mapsizehalfwidth = Game.mapSizeX/2
local mapsizehalfheight = Game.mapSizeZ/2

local CMD_FIGHT = CMD.FIGHT
local CMD_PATROL = CMD.PATROL
local CMD_REPAIR = CMD.REPAIR
local CMD_GUARD = CMD.GUARD
local CMD_RESURRECT = CMD.RESURRECT --125
local CMD_REMOVE = CMD.REMOVE
local CMD_RECLAIM = CMD.RECLAIM
local CMD_STOP = CMD.STOP
local CMD_INSERT = CMD.INSERT

local CMD_OPT_INTERNAL = CMD.OPT_INTERNAL

----- Type Tables
local canreclaim = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, corfast = true,
    armck = true, corck = true, armca = true, corca = true, armcs = true, corcs = true,
    armack = true, corack = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
}

local canrepair = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, corfast = true,
    armck = true, corck = true, armca = true, corca = true, armcs = true, corcs = true,
    armack = true, corack = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
}

local canassist = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, corfast = true,
    armack = true, corack = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
}

local canresurrect = {
    armrectr = true, corvrad = true, cornecro = true,
}

-----

function widget:PlayerChanged()
    if Spring.GetSpectatingState() and Spring.GetGameFrame() > 0 then
        widgetHandler:RemoveWidget(self)
    end
end

---- Disable widget if I'm spec
function widget:Initialize()
    if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
        widget:PlayerChanged()
    end
    local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID(), false)
    if spec then
        widgetHandler:RemoveWidget()
        return false
    end
    myTeamID = Spring.GetMyTeamID()
    local allUnits = spGetAllUnits()
    for i = 1, #allUnits do
        local unitID    = allUnits[i]
        local unitDefID = spGetUnitDefID(unitID)
        local unitTeam  = spGetUnitTeam(unitID)
        widget:UnitFinished(unitID, unitDefID, unitTeam)
    end
end

function widget:UnitCreated(unitID, unitDefID, teamID, builderID)
    -- If unit just created is a mobile unit, add it to array
    local uDef = UnitDefs[unitDefID]
    if not uDef.isImmobile then
        WIPmobileUnits[unitID] = true
    end
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    if myTeamID==spGetUnitTeam(unitID) then					--check if unit is mine

        local unitDef = UnitDefs[unitDefID]
        if unitDef.isBuilding == false then
            WIPmobileUnits[unitID] = false
        end
        if canreclaim[unitDef.name] or canresurrect[unitDef.name] then
            automatableUnits[unitID] = true

            Spring.Echo("Registering unit "..unitID.." as automatable"..unitDef.name)
            widget:UnitIdle(unitID, unitDefID, unitTeam)
        end
    end
end

----Add builder to the register
function widget:UnitIdle(unitID, unitDefID, unitTeam)
    if not automatableUnits[unitID] then
        return end
    --Spring.Echo("Unit ".. unitID.." is idle.") --UnitDefs[unitDefID].name)
    if myTeamID == spGetUnitTeam(unitID) and not unitsToAutomate[unitID] then		--check if unit is mine
        unitsToAutomate[unitID] = spGetGameFrame() + idlingDelay
        assistStoppedUnits[unitID] = false
        --Spring.Echo("Re-enabling assist for ".. unitID) --..UnitDefs[unitDefID].name)
        cancelAutoassistFor[unitID] = nil
    end
end

--Unregister automated unit once it is given a command
function widget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdOpts, cmdParams)

    --Spring.Echo("unit "..unitID.." got a command") --¤debug
    for builderID in pairs(automatedUnits) do
        if (builderID == unitID) then
            automatedUnits[builderID] = nil
            --Spring.Echo("unit ".. builderID .." is no longer idle")
        end
    end
    if cmdID < 0 then   -- build command was issued
        local nearFuture = spGetGameFrame() + orderRemovalDelay
        cancelAutoassistFor[unitID] = { frame = nearFuture, cmdID = cmdID, cmdOpts = cmdOpts, cmdParams = cmdParams }
    end
end
--
function widget:UnitDestroyed(unitID)
    unitsToAutomate[unitID] = nil
    automatedUnits[unitID] = nil
    assistStoppedUnits[unitID] = nil
    automatableUnits[unitID] = nil
end

---- Initialize the unit when received (shared)
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitFinished(unitID, unitDefID, unitTeam)
end

--TODO: Possible remove. If you don't have enough storage, that's your fault.
local function enoughEconomy()
    -- Validate for resources. If it's above 70% metal or energy, abort
    local currentM, currentMstorage = spGetTeamResources(myTeamID, "metal") --currentLevel, storage, pull, income, expense
    local currentE, currentEstorage = spGetTeamResources(myTeamID, "energy")
    if not isnumber(currentM) or not isnumber(currentE) then
        return false end
    --if currentM > currentMstorage * 0.3 and currentE > currentEstorage * 0.3 then
    --    Spring.Echo("Enough Eco!")
    --else
    --    Spring.Echo("NOPS eco!")
    --end
    return currentM > currentMstorage * 0.1 and currentE > currentEstorage * 0.1 --0.3
end

--- We use this to make sure patrol works, issuing two nearby patrol points
local function patrolOffset (x, y, z)
    local ofs = 50
    x = (x > mapsizehalfwidth ) and x-ofs or x+ofs   -- x ? a : b, in lua notation
    z = (z > mapsizehalfheight) and z-ofs or z+ofs

    return { x = x, y = y, z = z }
end

local function sqrDistance (pos1, pos2)
    if not istable(pos1) or not istable(pos2) or not pos1.x or not pos1.z or not pos2.x or not pos2.z then
        return 999999   -- keeping this huge so it won't affect valid nearest-distance calculations
    end
    return (pos2.x - pos1.x)^2 + (pos2.z - pos1.z)^2
end

local function getNearest (sourceUID, targets, isFeature)
    local nearestSqrDistance = 999999
    local nearestItemID

    local ox,oy,oz = spGetUnitPosition(sourceUID)
    local origin = {x = ox, y = oy, z = oz}
    for targetID in pairs(targets) do
        local x,y,z
        if isFeature then
            x,y,z = spGetFeaturePosition(targetID)
        else
            x,y,z = spGetUnitPosition(targetID) end
        local target = { x = x, y = y, z = z }
        local thisSqrDist = sqrDistance(origin, target)
        if isnumber(thisSqrDist) and isnumber(nearestSqrDistance)
                and (thisSqrDist < nearestSqrDistance) then
            nearestItemID = targetID
            nearestSqrDistance = sqrDistance
        end
    end
    return nearestItemID
end

-- typeCheck is a function (checking for true), if not defined it just returns the nearest unit
-- idCheck is a function (checking for true), checks the targetID to see if it fits a certain criteria
local function nearestItemAround(unitID, pos, unitDef, radius, typeCheck, idCheck, isFeature)
    local itemsAround = isFeature
            and spGetFeaturesInSphere(pos.x, pos.y, pos.z, radius, myTeamID)
            or spGetUnitsInSphere(pos.x, pos.y, pos.z, radius, myTeamID)
    if not istable(itemsAround) then
        return nil end
    local targets = {}
    for _,targetID in pairs(itemsAround) do
        if isFeature and spValidFeatureID(targetID) then
            local targetDefID = spGetFeatureDefID(targetID)
            local targetDef = (targetDefID ~= nil) and FeatureDefs[targetDefID] or nil
            --if targetDef and targetDef.isFactory then ==> eg.: function(x) return x.isFactory end
            if targetDef and (typeCheck == nil or typeCheck(targetDef))
                and (idCheck == nil or idCheck(targetID)) then
                targets[targetID] = true
            end
        elseif IsValidUnit(targetID) and targetID ~= unitID then
            local targetDefID = spGetUnitDefID(targetID)
            local targetDef = (targetDefID ~= nil) and UnitDefs[targetDefID] or nil
            if targetDef and (typeCheck == nil or typeCheck(targetDef))
                and (idCheck == nil or idCheck(targetID)) then
                targets[targetID] = true
            end
        end
    end
    return getNearest (unitID, targets, isFeature)
end

local function GetNearestValidTarget(unitID, unitDef)
    local pos = {}
    pos.x, pos.y, pos.z = spGetUnitPosition(unitID)
    local radius = unitDef.buildDistance * 1.2
    --local sqrRadius = radius ^ 2 -- builder build range, squared to speed up calculation
    local nearestSqrDistance = 999999
    local nearestUnitID = nil
    -- TODO: Support allied teams
    local unitsAround = spGetUnitsInCylinder(pos.x, pos.z, radius, myTeamID)
    if not istable(unitsAround) then
        return nil
    end
    for _,targetID in pairs(unitsAround) do
        if IsValidUnit(targetID) and targetID ~= unitID then
            local targetDefID = spGetUnitDefID(targetID)
            local targetDef = (targetDefID ~= nil) and UnitDefs[targetDefID] or nil
            if targetDef and not WIPmobileUnits[targetID] then --and not targetDef.isFactory
                local x, y, z = spGetUnitPosition(unitID)
                local targetPos = { x = x, y = y, z = z }
                local thisSqrDist = sqrDistance(pos, targetPos)
                if isnumber(thisSqrDist) and isnumber(nearestSqrDistance) then
                    if thisSqrDist < nearestSqrDistance then
                        nearestUnitID = targetID
                        nearestSqrDistance = sqrDistance
                    end
                end
            end
        end
    end
    return nearestUnitID
end

local function setAutomate(unitID)
    automatedUnits[unitID] = true  -- Flag auto-assisting unit for further command event processing
    unitsToAutomate[unitID] = nil
end

local function factoryIsBuilding(unitID)
    local buildqueue = spGetFullBuildQueue(unitID) -- => nil | buildOrders = { [1] = { [number unitDefID] = number count }, ... } }
    return buildqueue and #buildqueue > 0 or false
end

--- Decides and issues orders on what to do around the unit, in this order (1 == higher):
--- 1. If has no weapon (outpost, FARK, etc), reclaim enemy units;
--- 2. If can ressurect, ressurect nearest feature (check for economy? might want to reclaim instead)
--- 3. If can assist, guard nearest factory
--- 4. If can repair, repair nearest allied unit with less than 90% maxhealth.
--- 5. Reclaim nearest feature (prioritize metal)

local function automateCheck(unitID, unitDef)
    local x, y, z = spGetUnitPosition(unitID)
    local pos = { x = x, y = y, z = z }

    --Spring.Echo("Automatable auto-searching: "..unitID)
    local _orderIssued = false
    local radius = unitDef.buildDistance * 1.2

    --- 1. If has no weapon (outpost, FARK, etc), reclaim enemy units;
    local hasWeapon = unitDef.weapons[1]
    if not hasWeapon then
        Spring.Echo("[1] Fast-reclaim check")
        local nearestEnemy = spGetUnitNearestEnemy(unitID, radius, false) -- useLOS = false ; => nil | unitID
        if nearestEnemy then
            spGiveOrderToUnit(unitID, CMD_RECLAIM, nearestEnemy, {"meta"} ) --shift
            _orderIssued = true
        end
    end
    --- 2. If can ressurect, ressurect nearest feature (check for economy? might want to reclaim instead)
    if canresurrect[unitDef.name] and not _orderIssued then
        Spring.Echo("[2] Resurrect check")
        local nearestFeatureID = nearestItemAround(unitID, pos, unitDef, radius, nil, nil, true)
        if nearestFeatureID then
            local x,y,z = spGetFeaturePosition(nearestFeatureID)
            spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_RESURRECT, CMD_OPT_INTERNAL+1,x,y,z,20}, {"alt"})  --shift
            _orderIssued = true
        end
    end
    --- 3. If can assist, guard nearest factory
    if canassist[unitDef.name] and not _orderIssued then
        Spring.Echo("[3] Factory-assist check")
        --TODO: If during 'automation' it's guarding a factory but factory stopped production, remove it
        local nearestFactoryUnitID = nearestItemAround(unitID, pos, unitDef, radius,
                function(x) return x.isFactory end,     --We're only interested in factories currently producing
                function(x) return factoryIsBuilding(x) end)
        if nearestFactoryUnitID and enoughEconomy() then
            --Spring.Echo ("Autoassisting factory: "..(nearestFactoryUnitID or "nil").." has eco: "..tostring(enoughEconomy()))
            spGiveOrderToUnit(unitID, CMD_GUARD, { nearestFactoryUnitID }, {} )
            guardingUnits[unitID] = true
            _orderIssued = true
        end
    end
    --- 4. If can repair, repair nearest allied unit with less than 90% maxhealth.
    if canrepair[unitDef.name] and not _orderIssued then
        Spring.Echo("[4] Repair check")
        --TODO: Must check if the unit can assist or not (to assist building WIPmobileUnits)
        local nearestUnitID
        if canassist[unitID] then
            nearestUnitID = nearestItemAround(unitID, pos, unitDef, radius, nil,
                    function(x)
                        local health,maxHealth = spGetUnitHealth(x)
                        return health < (maxHealth * 0.99) end)
        else
            nearestUnitID = nearestItemAround(unitID, pos, unitDef, radius, nil,
                    function(x)
                        local health,maxHealth,_,_,done = spGetUnitHealth(x)
                        return done and health < (maxHealth * 0.99) end)
        end
        if nearestUnitID then
            --spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_REPAIR, CMD_OPT_INTERNAL+1,x,y,z,80}, {"alt"})
            spGiveOrderToUnit(unitID, CMD_REPAIR, { nearestUnitID }, {} )
            _orderIssued = true
        end
    end
    --- 5. Reclaim nearest feature (prioritize metal)
    if canreclaim[unitDef.name] and not _orderIssued then
        Spring.Echo("[5] Reclaim check")
        --TODO: This seems to be wrong (furthest feature instead of closest)
        local nearestFeatureID = nearestItemAround(unitID, pos, unitDef, radius, nil, nil, true)
        if nearestFeatureID then
            --spGiveOrderToUnit(unitID, CMD_INSERT, {0, CMD_RECLAIM, CMD.OPT_INTERNAL+1, { nearestFeatureID }}, {"alt"})
            --spGiveOrderToUnit(unitID,CMD_INSERT,{-1,CMD_CAPTURE,CMD_OPT_INTERNAL+1,unitID2},{"alt"});
            --spGiveOrderToUnit(unitID, CMD_RECLAIM, { nearestFeatureID }, {"alt"} )
            local x,y,z = Spring.GetFeaturePosition(nearestFeatureID)
            spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,80}, {"alt"})
            _orderIssued = true
        --else
        --    Spring.Echo("@autoassist: Nearest featureID not found")
        end --shift
    end
    if _orderIssued then
        Spring.Echo("@autoassist: Order issued")
        setAutomate(unitID) -- Flag auto-assisting unit for further command event processing
    end
end

function widget:CommandNotify(cmdID, params, options)
    --Spring.Echo("CommandID registered: "..(cmdID or "nil"))
    -- User commands are tracked here, check what unit(s) is/are selected and remove it from automatedUnits
    local selUnits = spGetSelectedUnits()  --() -> { [1] = unitID, ... }
    for _, unitID in ipairs(selUnits) do
        automatedUnits[unitID] = nil
    end
end

-- @Ivand: every frame mod 15 you should check builders queue (probably preselected set of builders who had guard/patrol command issued for them) and remove unwanted repair/reclaim etc from the front of the queue
-- or reimplement guard/patrol kludges in Lua

----Give idle builders an assist command every n frames
function widget:GameFrame(f)
    for unitID, data in pairs(cancelAutoassistFor) do
        -- Actual assist removal (a few frames after being issued)
        if IsValidUnit(unitID) and (not assistStoppedUnits[unitID]) and data.frame >= f then
            --Spring.Echo("Removing assist from ".. unitID)
            --spGiveOrderToUnit(uID, CMD_REMOVE, {CMD_PATROL, CMD_GUARD, CMD_RECLAIM, CMD_REPAIR}, {"alt"})
            --spGiveOrderToUnit(unitID, CMD_INSERT, {0, CMD_STOP, CMD.OPT_SHIFT}, {"alt"}) --
            spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_REPAIR }, { "alt"})
            spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_GUARD }, { "alt"})
            spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_PATROL }, { "alt"})
            spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_REPAIR }, { "alt"})
            spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_FIGHT }, { "alt"})
            automatedUnits[unitID] = nil
            assistStoppedUnits[unitID] = true
            --spGiveOrderToUnit(unitID, CMD_STOP, {}, {} )
        end
    end

    --local commandQueueSize = spGetCommandQueue(unitID, 0) --use 20 to limit this

    if f % idleCheckUpdateRate < 0.001 then
        for unitID, automateFrame in pairs(unitsToAutomate) do
            if f >= automateFrame and IsValidUnit(unitID)
                    and not automatedUnits[unitID] and not assistStoppedUnits[unitID] then
                local unitDef = UnitDefs[spGetUnitDefID(unitID)]
                Spring.Echo("Trying to automate unitID: "..unitID)
                --- unitsToAutomate[unitID] is only unset down the pipe, if automation is successful
                automateCheck(unitID, unitDef)
            end
        end
    end
    if f % automatedCheckUpdateRate < 0.001 then
        for unitID in pairs(automatedUnits) do
            if IsValidUnit(unitID) and not assistStoppedUnits[unitID] then
                local unitDef = UnitDefs[spGetUnitDefID(unitID)]    --TODO: Cache this within automatedUnits
                Spring.Echo("Rechecking automation of unitID: "..unitID)
                automateCheck(unitID, unitDef)
            end
        end
    end
end