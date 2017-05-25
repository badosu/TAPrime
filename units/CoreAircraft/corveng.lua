return {
	corveng = {
		acceleration = 0.83,
		airsightdistance = 950,
		brakerate = 0.065,
		buildcostenergy = 2800,
		buildcostmetal = 75,
		buildpic = "CORVENG.DDS",
		buildtime = 3333,
		canfly = true,
		canmove = true,
		category = "ALL MOBILE WEAPON VTOL ANTIFLAME ANTIEMG ANTILASER NOTLAND NOTSUB NOTSHIP NOTHOVER",
		collide = false,
		cruisealt = 110,
		description = "Fighter",
		explodeas = "smallExplosionGeneric",
		footprintx = 2,
		footprintz = 2,
		icontype = "air",
		maxdamage = 140,
		maxslope = 10,
		maxvelocity = 9.92,
		maxwaterdepth = 0,
		name = "Avenger",
		nochasecategory = "NOTAIR",
		objectname = "CORVENG",
		seismicsignature = 0,
		selfdestructas = "smallExplosionGeneric",
		sightdistance = 210,
		turnrate = 839,
		blocking = false,
		customparams = {
			
		},
		sfxtypes = { 
 			pieceExplosionGenerators = { 
				"deathceg3",
				"deathceg2",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "vtolcrmv",
			},
			select = {
				[1] = "vtolcrac",
			},
		},
		weapondefs = {
			corvtol_missile_a2a = {
				areaofeffect = 48,
				avoidfeature = false,
		    canattackground = false,
				collidefriendly = false,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				cegTag = "missiletrailfighter",
				explosiongenerator = "custom:genericshellexplosion-small-air",
				firestarter = 0,
				impulseboost = 0,
				impulsefactor = 0,
				metalpershot = 0,
				model = "missile",
				name = "GuidedMissiles",
				noselfdamage = true,
				range = 800,
				reloadtime = 0.9,
				smoketrail = false,
				soundhit = "xplosml2",
				soundhitwet = "splshbig",
				soundhitwetvolume = 0.5,
				soundstart = "Rocklit3",
				startvelocity = 360,
				texture2 = "coresmoketrail",
				tolerance = 12000,
				tracks = true,
				turnrate = 20000,
				weaponacceleration = 400,
				weapontimer = 4.25,
				weapontype = "MissileLauncher",
				weaponvelocity = 900,
				damage = {
					bombers = 125,
					fighters = 200,
					vtol = 125,
				},
				customparams = {
					light_skip = true,		-- used by projectile lights widget
				},
			},
			corvtol_missile_a2g = {
				areaofeffect = 48,
				avoidfeature = false,
				collidefriendly = false,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				cegTag = "missiletrailfighter",
				explosiongenerator = "custom:genericshellexplosion-small",
				firestarter = 0,
				impulseboost = 0,
				impulsefactor = 0,
				metalpershot = 0,
				model = "missile",
				name = "GuidedMissiles",
				noselfdamage = true,
				range = 470,
				reloadtime = 0.9,
				smoketrail = false,
				soundhit = "xplosml2",
				soundhitwet = "splshbig",
				soundhitwetvolume = 0.5,
				soundstart = "Rocklit3",
				startvelocity = 530,
				texture2 = "coresmoketrail",
				tolerance = 12000,
				tracks = true,
				turnrate = 24000,
				weaponacceleration = 400,
				weapontimer = 4.25,
				weapontype = "MissileLauncher",
				weaponvelocity = 900,
				damage = {
					commanders = 5,
					default = 23,
					subs = 5,
				},
			},
		},
		weapons = {
			[1] = {
				def = "CORVTOL_MISSILE_A2A",
				onlytargetcategory = "VTOL",
			},
			[2] = {
				def = "CORVTOL_MISSILE_A2G",
				onlytargetcategory = "NOTAIR",
			},
		},
	},
}
