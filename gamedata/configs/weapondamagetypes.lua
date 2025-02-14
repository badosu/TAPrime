--
-- Created by IntelliJ IDEA.
-- User: MaDDoX
-- Date: 14/05/17
-- Time: 04:16

-- Main damage type definition table. Keys are the unit name, value is a record table - weaponName,damageType
-- PS.: This table content was auto-generated with PrintWeaponDamageTypes() (@weapondefs_post.lua)

--- PS/2.: This only applies to Weapons defined *within* the unitDefs. For 'standalone' or 'shared' weapons (those
--- in the /weapons folder, the damageType is defined within its customParams entry. When used in the unit's .lua
--- UnitDef, that entry also *overrides* whatever's in here, so use it with discretion.

local weaponDamageTypes = {
	
--	armflash = { emgx = "bullet" },
--	armroy = { arm_roy = "cannon", depthcharge = "omni"},
	
	corsnap = { ["MediumPlasmaCannon"] = "cannon", },
	corsktl = { ["RailWeapon"]="thermo"}, --{ ["Mine Detonator"] = "omni", ["Crawlingbomb Dummy Weapon"] = "omni", ["RailWeapon"] = "rail" },
	cormort = { ["SiegeCannon"] = "siege", ["SiegeCannonAA"] = "siege", },
	armcroc = { ["PlasmaCannon"] = "cannon", },
	cormart = { ["PlasmaCannon"] = "siege", },
	corah = { ["Missiles"] = "rocket", },
	armmercury = { ["ADVSAM"] = "siege", },
	armthund = { ["Bombs"] = "explosive", },
	corcrw = { ["HighEnergyLaser"] = "neutron", ["PlasmaBeam"] = "plasma", },
	--armflea = { ["Laser"] = "laser", },
	armfig = { ["GuidedMissiles"] = "homing", ["GuidedMissilesA2G"] = "rocket",},
	armllt = { ["LightLaser"] = "hflaser", },
	corfgate = { ["NavalPlasmaRepulsor"] = "none", },
	corssub = { ["advTorpedo"] = "rocket", },
	corhurc = { ["AdvancedBombs"] = "explosive", },
	coraak = { ["Missiles"] = "rocket", ["MissilesAA"] = "homing", },
	armmship = { ["Rocket"] = "homing", ["Missiles"] = "siege", },
	corcom =  { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", ["J7NSLaser"] = "omni", },
    corcom1 = { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", ["J7NSLaser"] = "omni", },
	corcom2 = { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", ["J7NSLaser"] = "omni", },
	corcom3 = { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", ["J7NSLaser"] = "omni", ["CommanderShield"] = "omni", },
	corcom4 = { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", ["J7NSLaser"] = "omni", ["CommanderShield"] = "omni", },
    armcomboss = { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", ["J7NSLaser"] = "omni", ["CommanderShield"] = "omni", },
    corcomboss = { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", ["J7NSLaser"] = "omni", ["CommanderShield"] = "omni", },
	corpun = { ["PlasmaCannon"] = "explosive", ["NavalCannon"] = "explosive", },
	armbats = { ["BattleshipCannon"] = "plasma", },
	corfrt = { ["Missiles"] = "homing", ["MissilesAA"] = "homing", },
	armgate = { ["PlasmaRepulsor"] = "none", },
	corkarg = { ["FlakCannon"] = "flak", ["ShoulderRockets"] = "rocket", ["KarganethMissiles"] = "homing", },
	armroy = { ["HeavyCannon"] = "plasma", ["DepthCharge"] = "cannon", },
	corfmd = { ["Rocket"] = "omni", },
	corsh = { ["Laser"] = "homing", },
	corllt = { ["LightLaser"] = "hflaser", },
	armlun = { ["Guided Rockets"] = "cannon", ["DepthCharge"] = "homing", },
	armrock = { ["Rockets"] = "rocket", ["AARockets"] = "rocket",},
	armmav = { ["GaussCannon"] = "flak", },
	corsub = { ["Torpedo"] = "cannon", },
    armbeamer = { ["BeamLaser"] = "thermo", },
	armamex = { ["BeamLaser"] = "thermo", },
	corhllt = { ["LightLaser"] = "hflaser", },
	armyork = { ["FlakCannon"] = "flak", ["FlakAACannon"] = "flak", },
	armdeva = { ["FlakCannon"] = "flak", ["FlakAACannon"] = "flak", },
	corshred = { ["FlakCannon"] = "flak", ["FlakAACannon"] = "flak", },
	armhlt = { ["HighEnergyLaser"] = "hflaser", },
	armfido = { ["GaussCannon"] = "siege", ["BallisticCannon"] = "siege", },
	armpw = { ["peewee"] = "bullet", ["grenade"] = "hflaser", ["empexplosion"]="emp",},
    armmark = { ["smokebomb"] = "hflaser",},
	armmart = { ["PlasmaCannon"] = "siege", },
	coramph = { ["HighEnergyLaser"] = "laser", ["Torpedo"] = "rocket", },
	armcom =  { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", ["J7NSLaser"] = "omni", ["empexplosion"] = "emp", },
    armcom1 = { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", ["J7NSLaser"] = "omni",},
	armcom2 = { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", ["J7NSLaser"] = "omni", },
	armcom3 = { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", ["J7NSLaser"] = "omni", ["CommanderShield"] = "omni"},
	armcom4 = { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", ["J7NSLaser"] = "omni", ["CommanderShield"] = "omni"},
	armah = { ["Missiles"] = "rocket", },
	shiva = { ["HeavyRockets"] = "siege", ["HeavyCannon"] = "siege", },
	armorco = { ["FlakCannon"] = "homing", ["SuperEMG"] = "homing", ["RiotRockets"] = "homing", },
	corfhlt = { ["HighEnergyLaser"] = "neutron", },
	corsb = { ["CoreSeaAdvancedBombs"] = "rocket", },
	corscreamer = { ["ADVSAM"] = "siege", },
	armpincer = { ["PincerCannon"] = "cannon", },
	armpb = { ["GaussCannon"] = "cannon", },
	corfav = { ["Laser"] = "laser", },
	armsfig = { ["GuidedMissiles"] = "homing", },
	armham = { ["PlasmaCannon"] = "plasma", },
	armsub = { ["Torpedo"] = "cannon", },
	armsubk = { ["AdvancedTorpedo"] = "cannon", },
	corban = { ["Banisher"] = "plasma", },
	tawf009 = { ["AdvTorpedo"] = "rocket", },
	corcarry = { ["Rocket"] = "omni", },
	armptl = { ["Level1TorpedoLauncher"] = "homing", },
	armbull = { ["PlasmaCannon"] = "cannon", ["TankDepthCharge"] = "cannon", },
	armbrtha = { ["BerthaCannon"] = "siege", },
	corvipe = { ["GaussCannon"] = "cannon", },
	armsh = { ["Laser"] = "homing", },
	armtl = { ["Level1TorpedoLauncher"] = "cannon", },
	cormabm = { ["Rocket"] = "omni", },
	armsnipe = { ["SniperWeapon"] = "thermo", },
	corbhmth = { ["PlasmaBattery"] = "plasma", },
	armsaber = { ["LightningBolt"] = "bullet", },
	corenaa = { ["FlakCannon"] = "cannon", },
	corsent = { ["FlakCannon"] = "flak", ["FlakCannonAA"] = "flak", },
	armkam = { ["RiotRocket"] = "rocket", },
	corvamp = { ["GuidedMissiles"] = "homing", ["GuidedMissilesA2G"] = "homing", },
	meteor = { ["Asteroid"] = "siege", },
    meteorite = { ["Meteorite"] = "neutron", },
	corcan = { ["HighEnergyLaser"] = "neutron", },
	corlevlr = { ["RiotCannon"] = "explosive", },
	armwar = { ["MediumLaser"] = "laser", },
	corshark = { ["AdvancedTorpedo"] = "cannon", },
	armdecom = { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", },
	corbuzz = { ["RapidfireLRPC"] = "plasma", },
	corrl = { ["Missiles"] = "homing", ["AAMissiles"] = "homing", },
	corblackhy = { ["HighEnergyLaser"] = "neutron", ["BattleshipCannon"] = "plasma", ["RapidSamMissile"] = "plasma", },
	corgate = { ["PlasmaRepulsor"] = "none", },
	corhlt = { ["HighEnergyLaser"] = "hflaser", },
	armblade = { ["aircannon"] = "cannon", },
	armguard = { ["PlasmaCannon"] = "explosive", ["NavalCannon"] = "explosive"},
	cormh = { ["Rocket"] = "rocket", },
	tawf013 = { ["LightArtillery"] = "siege", },
	cormship = { ["Rocket"] = "homing", ["Missiles"] = "siege", },
	armaak = { ["Missiles"] = "rocket", ["MissilesAA"] = "homing", },
    armpship = { ["Missiles"] = "rocket", ["MissilesAA"] = "homing", },
    corpship = { ["Missiles"] = "rocket", ["MissilesAA"] = "homing", },
	armvulc = { ["RapidfireLRPC"] = "plasma", },
	corstorm = { ["Rockets"] = "rocket", ["AARockets"] = "rocket", },
	armamb = { ["PopupCannon"] = "explosive", },
	armmh = { ["RocketArtillery"] = "rocket", },
	armaas = { ["AA2Missile"] = "homing", ["FlakCannon"] = "flak", ["FlakAACannon"] = "flak",  },
	armrl = { ["Missiles"] = "homing", ["AAMissiles"] = "homing", },
	armamd = { ["Rocket"] = "omni", },
	marauder = { ["Missiles"] = "homing", ["MechPlasmaCannon"] = "homing", },
	armshock = { ["ShockerHeavyCannon"] = "omni", },
	armjuno = { ["AntiSignal"] = "omni", },
	armatl = { ["LongRangeTorpedo"] = "homing", },
	corape = { ["RiotRocket"] = "rocket", },
	corparrow = { ["PoisonArrowCannon"] = "cannon", },
	corroy = {  ["HeavyCannon"] = "plasma", ["DepthCharge"] = "cannon", },
	armfav = { ["HeavyRocket"] = "explosive", },
	cjuno = { ["AntiSignal"] = "omni", },
	armmerl = { ["Rocket"] = "explosive", },
	madsam = { ["AA2Missile"] = "homing", ["AA2AAMissile"] = "rocket",},
	armflash = { ["flash"] = "bullet", ["flashaa"] = "bullet", },
	corbw = { ["laser"] = "laser", ["Paralyzer"] = "emp", },
	corbats = { ["BattleshipCannon"] = "plasma", ["HighEnergyLaser"] = "plasma", },
	armfrt = { ["Missiles"] = "homing", ["MissilesAA"] = "homing", },
	armfhlt = { ["HighEnergyLaser"] = "neutron", },
	armseap = { ["TorpedoLauncher"] = "homing", },
	corshad = { ["Bombs"] = "explosive", },
	armsam = { ["Missiles"] = "rocket", ["AAMissiles"] = "homing", ["firerain"] = "thermo", },
	armcir = { ["ExplosiveRockets"] = "homing", ["ExplosiveRocketsAA"] = "homing", },
	corhrk = { ["HeavyFlak"] = "flak", },
	armfast = { ["ThermoBurst"] = "thermo", },
	armdecade = { ["flash"] = "homing", },
	armliche = { ["PlasmaImplosionDumpRocket"] = "nuke", },
	armjanus = { ["HeavyRocket"] = "laser", },
	corbow = { ["FlakCannon"] = "flak", ["AA2Missile"] = "homing", ["FlakAACannon"] = "flak", },
	corgol = { ["HeavyCannon"] = "cannon", },
	armpnix = { ["AdvancedBombs"] = "explosive", },
	armlance = { ["TorpedoLauncher"] = "homing", },
	armsb = { ["SeaAdvancedBombs"] = "rocket", },
	armfboy = { ["HeavyPlasma"] = "plasma", },
	armstump = { ["LightCannon"] = "cannon", ["TankDepthCharge"] = "cannon", },
	armsilo = { ["NuclearMissile"] = "nuke", },
	cormando = { ["CommandoBlaster"] = "thermo", ["CommandoMineLayer"] = "omni", },
	armzeus = { ["LightningGun"] = "thermo", },
	cormaw = { ["FlameThrower"] = "thermo", },
	corwolv = { ["LightArtillery"] = "siege", },
	corcut = { ["RiotCannon"] = "bullet", },
	--packo = { ["AA2Missile"] = "rocket", },
	armbrawl = { ["Machinegun"] = "laser", },
	corexp = { ["LightLaser"] = "bullet", },
	cortl = { ["Level1TorpedoLauncher"] = "cannon", },
	armanac = { ["MediumPlasmaCannon"] = "cannon", },
	armflak = { ["FlakCannon"] = "cannon", },
	armlatnk = { ["Missiles"] = "homing", ["LightningGun"] = "thermo", },
	corerad = { ["ExplosiveRockets"] = "homing", ["ExplosiveRocketsAA"] = "homing", },
	armraz = { ["MechRapidLaser"] = "thermo", },
	armepoch = { ["FlakCannon"] = "flak", ["BattleshipCannon"] = "plasma", ["BattleShipCannon"] = "plasma", },
	armanni = { ["ATA"] = "neutron", },
	armcrus = { ["CruiserCannon"] = "cannon", ["L2DeckLaser"] = "laser", ["CruiserDepthCharge"] = "cannon", },
	corsok = { ["Disruptor Phaser"] = "cannon", ["Torpedo"] = "homing", },
	nsaclash = { ["HighEnergyLaser"] = "homing", },
	armspid = { ["Paralyzer"] = "emp", },
	armpt = { ["Laser"] = "laser", ["Missiles"] = "homing", },
	coratl = { ["LongRangeTorpedo"] = "homing", },
	armcarry = { ["Rocket"] = "omni", },
	armjeth = { ["Missiles"] = "rocket", },
	corkrog = { ["KrogCrush"] = "omni", ["HeavyRockets"] = "rocket", ["GaussCannon"] = "plasma", ["KrogHeatRay"] = "thermo", },
	corgator = { ["Laser"] = "laser", ["LaserAA"] = "laser",},
	corint = { ["IntimidatorCannon"] = "siege", },
	armbanth = { ["HeavyRockets"] = "explosive", ["ImpulsionBlaster"] = "plasma", ["DEEEEEEWWWMMM"] = "neutron", },
	corcat = { ["RavenCatapultRockets"] = "rocket", },
	corflak = { ["FlakCannon"] = "cannon", },
	corptl = { ["Level1TorpedoLauncher"] = "homing", },
	corsumo = { ["HighEnergyLaser"] = "neutron", },
	krogtaar = { ["KrogTaarBlaster"] = "plasma", },
	armfflak = { ["FlakCannon"] = "cannon", },
	cortitan = { ["TorpedoLauncher"] = "homing", },
	corpyro = { ["FlameThrower"] = "thermo", },
	corsilo = { ["CoreNuclearMissile"] = "nuke", },
	corraid = { ["LightCannon"] = "cannon", ["TankDepthCharge"] = "cannon", },
	correap = { ["PlasmaCannon"] = "cannon", ["TankDepthCharge"] = "cannon", },
	cormexp = { ["HighEnergyLaser"] = "laser", ["RocketBattery"] = "rocket", },
	armmine1 = { ["Crawlingbomb Dummy Weapon"] = "bullet", ["Mine Detonator"] = "bullet", },
	armmine3 = { ["Crawlingbomb Dummy Weapon"] = "neutron", ["Mine Detonator"] = "neutron", },
	armfmine3 = { ["Crawlingbomb Dummy Weapon"] = "neutron", ["Mine Detonator"] = "neutron", },
	cormine4 = { ["CrawlingbombDummyWeapon"] = "flak", ["MineDetonator"] = "flak", },
	armemp = { ["EMPMissile"] = "emp", },
	corpt = { ["Laser"] = "laser", ["Missiles"] = "homing", },
	corcrus = { ["CruiserCannon"] = "cannon", ["L2DeckLaser"] = "laser", ["CruiserDepthCharge"] = "cannon", },
	cortrem = { ["RapidArtillery"] = "plasma", },
	cordoom = { ["HighEnergyLaser"] = "neutron", ["PlasmaBeam"] = "plasma", ["ATAD"] = "neutron", },
	armhawk = { ["HawkBeamer"] = "thermo", ["HawkBeamerA2G"] = "homing", },
	corsfig = { ["GuidedMissiles"] = "homing", },
	corthud = { ["PlasmaCannon"] = "plasma", },
    cordefiler = { ["FlakCannon"] = "flak", },
	armscab = { ["Rocket"] = "omni", },
	cortron = { ["TacticalNuke"] = "nuke", },
	corcrash = { ["Missiles"] = "rocket", },
	corak = { ["Laser"] = "laser", },
	cordecom = { ["Disintegrator"] = "omni", ["J7Laser"] = "omni", },
	corgarp = { ["PincerCannon"] = "cannon", },
	cortermite = { ["FlameThrower"] = "thermo", },
	corseal = { ["PlasmaCannon"] = "cannon", },
    corstil = { ["EMPbomb"] = "emp", },
	armsptk = { ["HeavyRocket"] = "rocket", },
	armst = { ["Gauss"] = "neutron", },
	cortoast = { ["PopupCannon"] = "explosive", },
	coresupp = { ["LightLaser"] = "homing", },
	cormist = { ["Missiles"] = "rocket", ["AAMissiles"] = "homing", ["smokebomb"] = "hflaser", },
	armfgate = { ["NavalPlasmaRepulsor"] = "plasma", },
	--armclaw = { ["LightningGun"] = "rocket", },
	cordl = { ["DepthCharge"] = "cannon", },
	corseap = { ["TorpedoLauncher"] = "homing", },
	corveng = { ["Machinegun"] = "bullet", ["MachinegunA2G"] = "bullet", },
	armmanni = { ["ATAM"] = "neutron", },
	armdfly = { ["Paralyzer"] = "emp", },
	corvroc = { ["Rocket"] = "siege", },
    corvrad = { ["neutronstriketagger"] = "thermo", },
	corjugg = { ["GaussCannon"] = "omni", ["LightLaser"] = "laser", },
	
	["else"] = {},
}

return weaponDamageTypes




