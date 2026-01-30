-- ===================================================================
-- DCS WORLD: MCDONNELL DOUGLAS DC-10-40 DEFINITION FILE
-- ===================================================================
-- VARIANT: DC-10-40 (Intercontinental)
-- ENGINES: 3x Pratt & Whitney JT9D-59A
-- ===================================================================

DC_10 =  {
    Name                = "DC_10",
    DisplayName         = _("DC-10-40"),
	date_of_introduction= 1972.11,
    Picture             = "DC-10.png",
    Rate                = "40",
    Shape               = "DC_10",
    WorldID             = WSTYPE_PLACEHOLDER,
	defFuelRatio    	= 0.8,
    singleInFlight      = true,

    -- ===================================================================
    -- 1. VISUAL MODEL & DESTRUCTION
    -- ===================================================================
    shape_table_data =
    {
        {
            file        = "DC_10",
            life        = 20,
            vis         = 3,
            desrt       = "kc-135-oblomok",
            fire        = { 300, 2},
            username    = "DC_10",
            index       = WSTYPE_PLACEHOLDER,
            classname   = "lLandPlane",
            positioning = "BYNORMAL",
        },
        {
            name        = "kc-135-oblomok",
            file        = "kc-135-oblomok",
            fire        = { 240, 2},
        },
    },

    mapclasskey = "P0091000029",
    attribute   = {wsType_Air, wsType_Airplane, wsType_Cruiser, WSTYPE_PLACEHOLDER, "Transports",},
    Categories  = { },

    -- ===================================================================
    -- 2. DIMENSIONS & GEOMETRY
    -- ===================================================================
    -- DC-10-40 shares the "Intercontinental" wing with the -30
    length      = 55.35,    -- [m] (181 ft 7 in)
    height      = 17.55,    -- [m] (57 ft 7 in)
    wing_span   = 50.39,    -- [m] (165 ft 4 in)
    wing_area   = 338.8,    -- [m^2] (3,647 sq ft)

    wing_tip_pos	= {-9.65,   0.46, 25.2},

    -- Landing Gear (Centerline gear present on -30 and -40)
	nose_gear_pos 	= 	{21.33, -5.25, -0.007233}, 		-- Nose gear position (ground under center of the axle)

	main_gear_pos 	= 	{-1.92, -5.105,  6.4},			-- Main gear position (ground under center of the axle)
														-- automatically mirrored

	nose_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (arg 2)
	nose_gear_amortizer_reversal_stroke 	 = -0.23851,-- Full Strut Compression (maximum+ weight on wheels)
	nose_gear_amortizer_normal_weight_stroke = -0.09938,-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	nose_gear_wheel_diameter				 =  1.129,	-- Diameter of the nose gear wheel (meters)

	main_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (args 4 and 6)
	main_gear_amortizer_reversal_stroke 	 = -0.19929,-- Full Strut Compression (maximum+ weight on wheels)
	main_gear_amortizer_normal_weight_stroke = -0.08304,-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	main_gear_wheel_diameter 				 =  1.535,	-- Diameter of the main gear wheels (meters)

	--[[
		tand_gear_max defines the Maximum Nose Wheel Steering Angle using the formula:
		
			tand_gear_max = math.tan(math.rad(gear_max_yaw_angle_deg))
		
		Desired Steering Angle	tand_gear_max 		Use Case
				25°					0.466			Older fighters, limited ground handling.
				30°					0.577			Standard runway operations.
				45°					1.000			High maneuverability (F-16/F-18 style NWS).
				60°					1.732			Carrier deck handling / Tight turns.
				75°					3.732			Extreme castering (rare).
	]]
	tand_gear_max	=	math.tan(math.rad(68)),


    -- ===================================================================
    -- 3. WEIGHT & MASS
    -- ===================================================================
    M_empty     = 122951,   -- [kg] (Heavier OEW for -40 vs -30)
    M_nominal   = 220000,   -- [kg] (Typical operational weight)
    M_max       = 251744,   -- [kg] (MTOW: 555,000 lbs)
    M_fuel_max  = 108149,   -- [kg] (Standard -30/-40 fuel capacity)

    -- ===================================================================
    -- 4. PERFORMANCE & SPEEDS
    -- ===================================================================
    -- Speed Limits
    V_opt           = 245,      -- [m/s TAS] Optimum cruise speed (Mach 0.82 Cruise)
    V_take_off      = 78,       -- [m/s TAS] Takeoff speed (~152 kts)
    V_land          = 72,       -- [m/s TAS] Landing speed (~140 kts Vref)
    V_max_sea_level = 206,      -- [m/s TAS] Maximum speed at "low level" (350 KCAS Vmo)
    V_max_h         = 272.4,    -- [m/s TAS] Maximum speed at high altitude (Mach 0.88 MMO)
    CAS_min         = 72,       -- [m/s TAS] Stall speed (~140 kts stall/min maneuvering)
    Mach_max        = 0.88,     -- MMO

    -- Altitude & Range
    H_max           = 12800,    -- [m] (Service Ceiling 42,000 ft)
    range           = 9400,     -- [km] (Slightly less than -30 due to fuel burn)

    -- Aerodynamic Performance
    Vy_max          = 10.5,     -- [m/s] (Slightly higher thrust improves climb)
    AOA_take_off    = math.rad(10), -- ~10 degrees
    bank_angle_max  = 35,       -- [degrees] Standard airline limit

    -- G-Limits
    Ny_min          =  -1.52,   -- [G]
    Ny_max          =  2.0,		-- [G]
    Ny_max_e        =  2.5,		-- [G]



	-- ===================================================================
    -- INERTIA & CG
    -- ===================================================================
--[[
	DCS uses the TsAGI coordinate system, which uses different axis labels and different conventions than the West.
	
	In the West/USA, the spatial order {x,y,z} is:
		x		Longitudinal axis 	(+x forward toward nose)
		y		Lateral/span axis 	(+y right toward starboard wingtip)
		z		Vertical axis 		(+z DOWN toward earth when airframe is level)
		
	In the Russian/TsAGI system (and DCS), the spatial order {x,y,z} is:
		x		Longitudinal axis	(+x forward toward nose)
		y		Vertical axis		(+y UP away from earth when airframe is level)
		z		Lateral/span axis	(+z right toward starboard wingtip)
		
	Both systems place the spatial origin (i.e., {0, 0, 0}) at the center of gravity (CG).
	
	
	Likewise, for moments of inertia (MOI), the axes have different labels/letters than the West.
	
	In the West/USA, the MOI order {I_xx,I_yy,I_zz} is:
		I_xx	Roll inertia 		(rotation about the longitudinal axis)
		I_yy	PITCH inertia 		(rotation about the spanwise/wing axis)
		I_zz	YAW inertia 		(rotation about the vertical axis)
		
	In the Russian/TsAGI system (and DCS), the MOI order {I_xx,I_yy,I_zz} is:
		I_xx	Roll inertia 		(rotation about the longitudinal axis)
		I_yy	YAW inertia 		(rotation about the vertical axis)
		I_zz	PITCH inertia 		(rotation about the spanwise/wing axis)
		
	* Note: MOIs cannot be negative.
	
	
	Finally, there is the relevant Product of Inertia (POI) which has different notation
	for the PLANE OF SYMMETRY in the two systems.
	
	The "Plane of Symmetry" is the 2D plane which slices the pilot in half vertically;
	i.e., the left side of the plane is a mirror-image of the right side and the "mirror"
	is the plane of symmetry. For non-saucer or ball-shaped bodies there are no other
	planes of symmetry.
	
	In the West/USA, the plane of symmetry is the X-Z plane. Recall:
		x		Longitudinal axis 	(+x forward toward nose)
		z		Vertical axis 		(+z DOWN toward earth when airframe is level)
	
	The associated POI notation is I_xz.
	
	
	In the Russian/TsAGI system (and DCS), the plane of symmetry is the X-Y plane. Recall:
		x		Longitudinal axis	(+x forward toward nose)
		y		Vertical axis		(+y UP away from earth when airframe is level)
	
	The associated POI notation is I_xy.
	
	
	Note: the POI can be positive OR NEGATIVE!
	
	Example:
		Consider a high T-Tail airplane (i.e., most of the mass is above and behind the CG).
		
		I_uv	=	Sum( mass * u_coord * v_coord )		[it's really an integral over u and v]
	
	1. Western calculation (I_xz):
		Recall:
			x 	Longitudinal axis 		(+x forward toward nose)
			z	Vertical axis 			(+z DOWN toward earth when airframe is level)
		
		The Ix moment contribution should be negative since the mass is located behind the CG.
		That is, the mass centroid is located on the -x side.
		
		The Iz moment contribution should also be NEGATIVE since the mass is located
		above the CG. Why? Because +z is defined as DOWN, so the mass centroid is Located
		on the -z side.
		
		I_xz 	=	(-X) * (-Z)		=	Positive number
		
	2. TsAGI calculation (I_xy):
		Recall:
			x		Longitudinal axis	(+x forward toward nose)
			y		Vertical axis		(+y UP away from earth when airframe is level)
		
		The Ix moment contribution should be negative since the mass is located behind the CG,
		just like in the example for the Western system. The mass centroid is located on the
		-x side.
		
		The Iy moment contribution should also be POSITIVE since the mass is located
		above the CG. Why? Because +y is defined as UP and the mass centroid is Located
		on the +y side.
		
		I_xy 	=	(-X) * (+Y)		=	NEGATIVE number
		
	Conversion rule:
	
				(West notation) I_xz  ~=  -I_xy (TsAGI notation)
				
	Summary conversion table:
	+------------------+----------------+------------------------------------------------+
	| Source (Western) | Target (TsAGI) | Logic                                          |
	+------------------+----------------+------------------------------------------------+
	|      I_xx        |      I_xx      | Roll is Roll (axis is the same).               |
	|      I_yy        |      I_zz      | TsAGI Pitch (Z) takes Western Pitch (Y) value. |
	|      I_zz        |      I_yy      | TsAGI Yaw (Y) takes Western Yaw (Z) value.     |
	|      I_xz        |     −I_xy      | Take Western value and FLIP THE SIGN.          |
	+------------------+----------------+------------------------------------------------+
]]
--[[
	DCS moments of inertia (MOI) and product of inertia (POI) expect values (in metric)
	for an empty airframe. DCS will add the mass of fuel, munitions, etc., but it cannot
	magically know the MOIs or POI without direct declaration in a known mass configuration.
	
	Since MOI is always non-negative, as long as you pay attention to the coordinate
	system your source document uses and you're mapping to the appropriate TsAGI
	{Roll, Yaw, Pitch} or {Roll, Yaw, Pitch, POI} order that DCS uses and expects,
	you cannot mess up the sign.
	
	POI is different since it's a signed value AND the sign flips if copying from source
	material which uses Western coordinate systems/conventions.
	
	Carefully consider the summary conversion table in the MOI/POI section above, and 
	consider the POI sign example to double-check yourself that you've entered the POI 
	with the correct sign in DCS.
	
	Reminder: MOI and POI units for DCS should be kg*m^2. POI is optional.
	DCS MOI + optional POI order:	{Roll, Yaw, Pitch, POI}
]]
	-- DCS Empty Weight CG (relative to 3D mesh origin, +x fwd, +y up, +z right)
	-- center of mass position relative to object 3d model center for empty aircraft [m]
	-- in TsAGI coordinate system.
    center_of_mass      = { -1.80, 0.10, 0.0 },				-- [m] CG w.r.t. EDM 3D mesh origin in TsAGI coordinate order

--[[
	MOI and POI (EMPTY configuation) in TsAGI coordinate system.
 
	POI sign check:
	Airliners typically have heavy, podded engines located below the wing (-Y in TsAGI) and
	generally forward of the Center of Gravity (+X), while the empennage/tail (-X)
	structure is high (+Y). The sum of those products should be NEGATIVE.
	
]]
	moment_of_inertia	= {24.5e6, 60.6e6, 54.7e6, -1.1e6},	-- [kg*m^2] {Roll, Yaw, Pitch, POI}




    -- ===================================================================
    -- 5. ENGINE & FUEL (3x P&W JT9D-59A)
    -- ===================================================================

	-- Thrust Total (3 engines combined)
    -- 3 x 53,000 lbf = 159,000 lbf = ~707,260 N
    thrust_sum_max  = 72124,   -- [kgf] Combined thrust
    thrust_sum_ab   = 72124,   -- [kgf] Combined thrust w/afterburner

    -- Fuel Consumption
    -- JT9D-59A burn is higher than CF6. Approx 2.92 kg/sec total cruise.
    average_fuel_consumption = 2.92, -- [kg/sec] Aveerage fuel consumption at cruise

    -- Engine Nozzles

	engines_count	=	3,
	engines_startup_sequence = { 1, 2, 0 },
    engines_nozzles =
    {
		[1] = -- Left Wing Engine
        {
            pos                 = {1.66, -2.7139, -9.021},	-- #1 Engine
            elevation			= -2.5,	-- 2.5 degree exhaust depression (negative means exhaust points down)
			azimuth             = 2.0,	-- 2.0 degree toe-in (positive means thrust vector points toward longitudinal axis; exhaust points away)
            diameter            = 1.21,
            exhaust_length_ab   = 9.144,
            exhaust_length_ab_K = 0.76,
            smokiness_level     = 0.14, -- JT9D was known to be smokier than CF6
			engine_number       = 1,
        },
        [2] = -- Tail Engine
        {
            pos                 = {-27.6, 4.797, 0}, 		-- #2 Engine (Tail)
            elevation			= 2.5,	-- 2.5 degree exhaust inclination (positive means exhaust points up)
			azimuth             = 0.0,
            diameter            = 1.21,
            exhaust_length_ab   = 9.144,
            exhaust_length_ab_K = 0.76,
            smokiness_level     = 0.14, -- JT9D was known to be smokier than CF6
			engine_number       = 2,
        },
        [3] = -- Right Wing Engine
        {
            pos                 = {1.66, -2.7139, 9.021},	-- #3 Engine
            elevation			= -2.5,	-- 2.5 degree exhaust depression (negative means exhaust points down)
			azimuth             = -2.0,	-- 2.0 degree toe-in (negative means thrust vector points toward longitudinal axis; exhaust points away)
            diameter            = 1.21,
            exhaust_length_ab   = 9.144,
            exhaust_length_ab_K = 0.76,
            smokiness_level     = 0.14, -- JT9D was known to be smokier than CF6
			engine_number       = 3,
        },
    },

    -- ===================================================================
    -- 6. SYSTEMS & CREW
    -- ===================================================================
    crew_size       = 3, -- Pilot, Co-Pilot, Flight Engineer
    crew_members = {
        [1] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {27.958, 1.4064, -0.6398} },
        [2] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {27.958, 1.4064,  0.6696} },
        [3] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {26.969, 1.4064,  0.0046} },
    },

    has_afteburner              = false,
    has_speedbrake              = true,
    has_thrustReverser          = true,
    has_differential_stabilizer = false,
    radar_can_see_ground        = false,
    stores_number               = 0,
    tanker_type                 = 0,
    flaps_maneuver              = 15/50,			-- Corresponds to Flaps 15, dial-a-flap maxes at 50 degrees.
    brakeshute_name             = 0,
    is_tanker                   = false,
	flaps_transmission          = "Hydraulic",
    undercarriage_transmission  = "Hydraulic",

    -- Detection & Stealth
    RCS                     = 85, 		-- [m^2] Large RCS for widebody
    detection_range_max		= 30,		-- [km] Distance pilots in this airframe can possibly become aware of other airframes
    IR_emission_coeff       = 2.5, 		-- Three large, older-generation high-bypass engines. Significant heat bloom from the tail-mounted #2 engine.
    IR_emission_coeff_ab    = 0,

    CanopyGeometry = {
        azimuth = {-110.0, 110.0},
        elevation = {-30.0, 60.0},
    },

    Failures = {
        { id = 'asc',       label = _('ASC'),       enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'autopilot', label = _('AUTOPILOT'), enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'hydro',     label = _('HYDRO'),     enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'l_engine',  label = _('L-ENGINE'),  enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'r_engine',  label = _('R-ENGINE'),  enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
    },

    HumanRadio = {
		frequency = 127.5,
		editable = true,
		minFrequency = 118.000,
		maxFrequency = 137.000,
		modulation = MODULATION_AM
	},

    Pylons = { },
    Tasks = { aircraft_task(Transport), },
    DefaultTask = aircraft_task(Nothing),

    -- ===================================================================
    -- 7. SFM DATA (FLIGHT MODEL)
    -- ===================================================================
    SFM_Data = {
        aerodynamics = {
            -- Control authority parameters
            Cy0         = 0.050,    -- Lift at zero AOA (Clean)
            Mzalfa      = 5.0,      -- Pitch stability (Heavy Transport)
            Mzalfadt    = 1.0,      -- Pitch damping
            kjx         = 2.6,      -- Roll inertia (Widebody)
            kjz         = 0.0012,   -- Pitch inertia
            Czbe        = -0.016,   -- Directional stability

            -- Drag coefficients
            cx_gear     = 0.030,    -- High drag (3 main gear bogies)
            cx_flap     = 0.100,    -- Large double-slotted flaps
            cy_flap     = 0.70,     -- Flap lift
            cx_brk      = 0.06,    	-- Spoiler drag

            table_data = {
				-- Aerodynamic Drag Polar Table
				-- M: Mach, Cx0: Zero-lift drag, Cya: Normal force coeff, B/B4: Polar shape
				-- Omxmax: Roll rate, Aldop: Max AoA, Cymax: Max Lift
                -- 		 M      Cx0     Cya      B        B4    Omxmax   Aldop   Cymax

                -- Low speed / Takeoff / Landing
				[1]  = {0.0,   0.020,  0.130,  0.060,   0.004,   0.40,   15.0,   1.72},
				[2]  = {0.2,   0.020,  0.130,  0.061,   0.006,   0.42,   15.0,   1.72},
				[3]  = {0.4,   0.021,  0.125,  0.063,   0.011,   0.42,   14.8,   1.60},

				-- Climb
				[4]  = {0.6,   0.023,  0.140,  0.068,   0.018,   0.42,   14.5,   1.46},

				-- Cruise
				[5]  = {0.78,  0.029,  0.145,  0.092,   0.035,   0.40,   13.8,   1.38},
				[6]  = {0.80,  0.030,  0.142,  0.100,   0.040,   0.38,   13.5,   1.34},
				[7]  = {0.82,  0.032,  0.140,  0.108,   0.044,   0.38,   13.0,   1.30},
				[8]  = {0.84,  0.034,  0.138,  0.118,   0.050,   0.35,   12.8,   1.26},

				-- MMO approach
				[9]  = {0.85,  0.037,  0.120,  0.135,   0.058,   0.33,   12.5,   1.22},
				[10] = {0.88,  0.055,  0.100,  0.185,   0.080,   0.30,   12.0,   1.12},

				-- Overspeed
				[11] = {0.90,  0.075,  0.085,  0.255,   0.115,   0.25,   11.0,   1.00},
				[12] = {0.92,  0.100,  0.071,  0.360,   0.165,   0.20,   10.0,   0.85},
				[13] = {1.0,   0.180,  0.060,  0.650,   0.300,   0.15,   7.0,    0.50},
            },
        },

        engine = {
            typeng  	= 4,        	-- E_TURBOFAN
			type 		= "TurboFan",

            -- RPM (Pratt & Whitney JT9D-59A Data)
            -- JT9D has lower rotor speeds than CF6
            Nmg     	= 60.5,   		-- N2 Idle RPM %
			Nominal_RPM = 8011.0,		-- N2 (High Compressor) 100%
			Nominal_Fan_RPM = 3780.0, 	-- N1 (Fan) 100%

            MinRUD  	= 0,
            MaxRUD  	= 1,
            MaksRUD 	= 1,
            ForsRUD 	= 1,

            -- Performance Envelope
            hMaxEng 	= 13.8,     -- [km] Max engine altitude (flameout altitude)
            dcx_eng 	= 0.0150,   -- Increased nacelle drag (Bulbous P&W nacelle)

            -- Fuel Flow (JT9D-59A)
            -- TSFC of ~0.63 lb/lbf/h for JT9D-59A; yields realistic
			-- burn rates of ~10,500 kg/h at cruise thrust
            cemax   	= 0.63,     -- [kg/kgf/h] scaled
            cefor   	= 0.63,     -- [kg/kgf/h] scaled

            -- Altitude compensation
			-- Standard for high-bypass turbofans to approximate
			-- thrust lapse (~30% at cruise altitude)
            dpdh_m		= 38000,	-- [N/km per engine]
            dpdh_f		= 38000,	-- 35500?

            table_data = {
                -- THRUST (3x JT9D-59A)
                -- Total Static: 707.4 kN (3x 53,000 lbf = 235.7 kN each)
                -- CORRECTED: Flatter curve to support high altitude cruise
				[1] = {0.0,    707400,     707400}, -- Static
				[2] = {0.2,    700000,     700000},
				[3] = {0.4,    695000,     695000},
				[4] = {0.6,    690000,     690000},
				[5] = {0.7,    685000,     685000},
				[6] = {0.8,    680000,     680000}, -- Cruise Base (Net ~145kN at FL360)
				[7] = {0.85,   650000,     650000},
				[8] = {0.9,    500000,     500000},
            },
        },
    },

    -- ===================================================================
    -- 8. DAMAGE MODEL
    -- ===================================================================
    Damage = {
        [0]  = {critical_damage = 5, args = {146}}, -- NOSE_CENTER
        [1]  = {critical_damage = 3, args = {296}}, -- NOSE_LEFT_SIDE
        [2]  = {critical_damage = 3, args = {297}}, -- NOSE_RIGHT_SIDE
        [3]  = {critical_damage = 8, args = {65}},  -- COCKPIT
        [4]  = {critical_damage = 2, args = {298}}, -- CABIN_LEFT_SIDE
        [5]  = {critical_damage = 2, args = {301}}, -- CABIN_RIGHT_SIDE
        [7]  = {critical_damage = 2, args = {249}}, -- GUN (N/A)
        [8]  = {critical_damage = 3, args = {265}}, -- FRONT_GEAR_BOX
        [9]  = {critical_damage = 3, args = {154}}, -- FUSELAGE_LEFT_SIDE
        [10] = {critical_damage = 3, args = {153}}, -- FUSELAGE_RIGHT_SIDE
        [11] = {critical_damage = 1, args = {167}}, -- ENGINE_L
        [12] = {critical_damage = 1, args = {161}}, -- ENGINE_R
        [13] = {critical_damage = 2, args = {169}}, -- MTG_L_BOTTOM
        [14] = {critical_damage = 2, args = {163}}, -- MTG_R_BOTTOM
        [15] = {critical_damage = 2, args = {267}}, -- LEFT_GEAR_BOX
        [16] = {critical_damage = 2, args = {266}}, -- RIGHT_GEAR_BOX
        [17] = {critical_damage = 2, args = {168}}, -- ENGINE_L_OUT
        [18] = {critical_damage = 2, args = {162}}, -- ENGINE_R_OUT
        [20] = {critical_damage = 2, args = {183}}, -- AIR_BRAKE_R
        [23] = {critical_damage = 5, args = {223}}, -- WING_L_OUT
        [24] = {critical_damage = 5, args = {213}}, -- WING_R_OUT
        [25] = {critical_damage = 2, args = {226}}, -- ELERON_L
        [26] = {critical_damage = 2, args = {216}}, -- ELERON_R
        [29] = {critical_damage = 5, args = {224}, deps_cells = {23, 25}}, -- WING_L_CENTER
        [30] = {critical_damage = 5, args = {214}, deps_cells = {24, 26}}, -- WING_R_CENTER
        [35] = {critical_damage = 6, args = {225}, deps_cells = {23, 29, 25, 37}}, -- WING_L_IN
        [36] = {critical_damage = 6, args = {215}, deps_cells = {24, 30, 26, 38}}, -- WING_R_IN
        [37] = {critical_damage = 2, args = {228}}, -- FLAP_L_IN
        [38] = {critical_damage = 2, args = {218}}, -- FLAP_R_IN
        [39] = {critical_damage = 2, args = {244}, deps_cells = {53}}, -- FIN_L_TOP
        [40] = {critical_damage = 2, args = {241}, deps_cells = {54}}, -- FIN_R_TOP 
        [43] = {critical_damage = 2, args = {243}, deps_cells = {39, 53}}, -- FIN_L_BOTTOM
        [44] = {critical_damage = 2, args = {242}, deps_cells = {40, 54}}, -- FIN_R_BOTTOM 
        [51] = {critical_damage = 2, args = {240}}, -- ELEVATOR_L_IN
        [52] = {critical_damage = 2, args = {238}}, -- ELEVATOR_R_IN
        [53] = {critical_damage = 2, args = {248}}, -- RUDDER_L
        [54] = {critical_damage = 2, args = {247}}, -- RUDDER_R
        [56] = {critical_damage = 2, args = {158}}, -- TAIL_LEFT_SIDE
        [57] = {critical_damage = 2, args = {157}}, -- TAIL_RIGHT_SIDE
        [59] = {critical_damage = 3, args = {148}}, -- NOSE_BOTTOM
        [61] = {critical_damage = 2, args = {147}}, -- FUEL_TANK_F
        [82] = {critical_damage = 2, args = {152}}, -- FUSELAGE_BOTTOM
        [105]= {critical_damage = 2, args = {603}}, -- ENGINE_3
        [106]= {critical_damage = 2, args = {604}}, -- ENGINE_4
    },

    DamageParts =
    {
        [1] = "DC_10-OBLOMOK-WING-R",
        [2] = "DC_10-OBLOMOK-WING-L",
    },

    fires_pos =
    {
        [1] =   {7.166, -1.843, 0},
        [2] =   {3.863, -0.629, 2.578},
        [3] =   {3.863, -0.629, -2.578},
        [4] =   {-0.82, 0.265, 2.774},
        [5] =   {-0.82, 0.265, -2.774},
        [6] =   {-0.82, 0.255, 4.274},
        [7] =   {-0.82, 0.255, -4.274},
        [8] =   {5.354, -1.868, 8.017},
        [9] =   {5.354, -1.868, -8.017},
        [10] =  {-23.974, 4.877, 0},
        [11] =  {-23.974, 4.877, 0},
    },


	-- ============================================================
	-- LIGHTS DEFINITION
	-- ============================================================

	--[[
		--------------------------------------------------------------
		------------------  HawaiianRyan overhaul  -------------------
		--------------------------------------------------------------
		DCS World\Scripts\Aircrafts\_Common\Lights.lua
		
		WOLALIGHT_STROBES          = 1		-- White strobe anti-collision lights.
		WOLALIGHT_SPOTS            = 2		-- Take-off and landing high power headlights.
		WOLALIGHT_LANDING_LIGHTS   = 2		-- Take-off and landing high power headlights.
		WOLALIGHT_NAVLIGHTS        = 3		-- P-Z colored navigation (position) wingtip lights..
		WOLALIGHT_FORMATION_LIGHTS = 4		-- Formation / Logo lights.
		WOLALIGHT_TIPS_LIGHTS      = 5		-- Helicopter-specific: rotor anti-collision tips lights.
		WOLALIGHT_TAXI_LIGHTS      = 6		-- Taxi headlights.
		WOLALIGHT_BEACONS          = 7		-- Rotary anti-collision lights.
		WOLALIGHT_CABIN_BOARDING   = 8		-- Cabin incandescence illumination.
		WOLALIGHT_CABIN_NIGHT      = 9		-- Cabin night time (UV) illumination.
		WOLALIGHT_REFUEL_LIGHTS    = 10		-- Refuel apparatus illumination.
		WOLALIGHT_PROJECTORS       = 11		-- Search lights, direction-controlled.
		WOLALIGHT_AUX_LIGHTS       = 12		-- White anti-collision strobes & others
		WOLALIGHT_IR_FORMATION     = 13		-- IR formation strips. Currently not implemented due to engine NVG limitations.
		WOLALIGHT_CABIN_WORK	   = 14		-- Flight instrument illumination of pilots
	]]

    lights_data = {
	typename = "collection", lights = {

        [WOLALIGHT_NAVLIGHTS] = {
            typename = "Collection",
            lights = {
                [1] = {
                    typename = "collection",
                    lights = {
						{
							typename = "Spot", position = { -25.8, 2.0, 0 },
							direction = {azimuth = math.rad(180.0)},
							proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(140.0), angle_min = math.rad(0),
						},
						{
							typename = "Omni", position = { -25.8, 2.0, 0 },
							proto = lamp_prototypes.ANO_3_Bl, movable = true,
						},
						{
							typename = "Spot", position = { -9.316712, 0.440826, -25.289371 },
							direction = {azimuth = math.rad(-60.0), elevation = math.rad(0)}, argument = 190,
							proto = lamp_prototypes.BANO_8M_red, angle_max = math.rad(120.0), angle_min = math.rad(0),
						},
						{
							typename = "Spot", position = { -9.310573, 0.469207, 25.185984 },
							direction = {azimuth = math.rad(60.0), elevation = math.rad(0)}, argument = 191,
							proto = lamp_prototypes.BANO_8M_green, angle_max = math.rad(120.0), angle_min = math.rad(0),
						},

						{	-- port aft-facing white tail light. Source: http://www.arcforums.com/forums/air/index.php?/topic/192063-dc-10-lights/
                            typename = "Spot", position = { -12.65, 0.4590, -25.145 },
							direction = {azimuth = math.rad(180.0)},
							proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(140.0), angle_min = math.rad(0), cool_down_t = 0.8,
                        },
						{
							typename = "Omni", position = { -12.65, 0.4590, -25.145 },
							proto = lamp_prototypes.ANO_3_Bl, movable = true,
						},
						{	-- starboard aft-facing white tail light. Source: http://www.arcforums.com/forums/air/index.php?/topic/192063-dc-10-lights/
                            typename = "Spot", position = { -12.65, 0.4590, -25.145 },
							direction = {azimuth = math.rad(180.0)},
							proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(140.0), angle_min = math.rad(0), cool_down_t = 0.8,
                        },
						{
							typename = "Omni", position = { -12.65, 0.4590, -25.145 },
							proto = lamp_prototypes.ANO_3_Bl, movable = true,
						},

						{	-- port empennage logo illumination. Source: https://commons.wikimedia.org/wiki/File:McDonnell_Douglas_DC-10-30,_Air_Zaire_AN0199454.jpg
                            typename = "Spot",  position = { -24.000, 1.900, -8.00 },
							direction = {azimuth = math.rad(68.0), elevation = math.rad(-47.0)},
                            proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(80.0), angle_min = math.rad(0.0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.2, movable = true,
                        },
						{	-- starboard empennage logo illumination. Source: https://commons.wikimedia.org/wiki/File:McDonnell_Douglas_DC-10-30,_Air_Zaire_AN0199454.jpg
                            typename = "Spot",  position = { -24.000, 1.900, 8.00 },
							direction = {azimuth = math.rad(-68.0), elevation = math.rad(-47.0)},
                            proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(80.0), angle_min = math.rad(0.0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.2, movable = true,
                        },

						-- Wing illumination. Source: http://www.arcforums.com/forums/air/index.php?/topic/192063-dc-10-lights/
						{
							typename = "Spot",  position = { 9.100, 0.680, -3.25 },
							direction = {azimuth = math.rad(-135.0), elevation = math.rad(0.0)},
							proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(22.0), angle_min = math.rad(0.0),
							cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
						{
							typename = "Spot",  position = { 9.100, 0.680, 3.25 },
							direction = {azimuth = math.rad(135.0), elevation = math.rad(0.0)},
							proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(22.0), angle_min = math.rad(0.0),
							cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
                    },
                },
            },
        },
        [WOLALIGHT_SPOTS] = {
            typename = "Collection",
            lights = {
                [1] = {
                    typename = "collection",
                    lights = {
                        {
                            typename = "Spot", position = { 21.287432, -2.901209, 0.00 }, argument = 51,
							direction = {azimuth = math.rad(0.0), elevation = math.rad(5.0)},
                            proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(30.0), angle_min = math.rad(0),
							cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 24.100, -1.300, -2.500 },
							direction = {azimuth = math.rad(-7.0), elevation = math.rad(8.0)},
                            proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 24.100, -1.300, 2.500 },
							direction = {azimuth = math.rad(7.0), elevation = math.rad(8.0)},
                            proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                    },
                },
            },
        },
        [WOLALIGHT_TAXI_LIGHTS] = {
            typename = "Collection",
            lights = {
                [1] = {
                    typename = "collection",
                    lights = {
						{
							typename = "Spot", position = { 21.287432, -2.901209, 0.00 }, argument = 51,
							direction = {azimuth = math.rad(0.0), elevation = math.rad(5.0)},
							proto = lamp_prototypes.LFS_R_27_250, cool_down_t = 0.5, movable = true,
						},
						{
							typename = "Omni", position = { 21.387432, -2.901209, 0.00 },
							proto = lamp_prototypes.LFS_R_27_250, cool_down_t = 0.5, range = 6.0, movable = true,
						},

						-- Runway turnoff lights. These really ought to be animated as part of the wheel steering mechanism, but I don't know how to do that.
						{
                            typename = "Spot",  position = { 11.300, -0.600, -3.100 },
							direction = {azimuth = math.rad(-38.0), elevation = math.rad(10.0)},
                            proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(45.0), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						{
                            typename = "Spot",  position = { 11.300, -0.600, 3.100 },
							direction = {azimuth = math.rad(38.0), elevation = math.rad(10.0)},
                            proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(45.0), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                    },
                },
            },
        },

		[WOLALIGHT_BEACONS] = {
			-- Source: http://www.arcforums.com/forums/air/index.php?/topic/192063-dc-10-lights/    and    https://www.youtube.com/watch?v=EMzBSU-dlSM
            typename = "collection",
            lights = {
                [1] = {
                    typename = "Collection",
                    lights = {
                        {
                            typename = "natostrobelight", position = { 3.500, 3.800, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { -8.000, -2.900, 0.000},
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.5,
                        },
                    },
                },
            },
        },
        [WOLALIGHT_STROBES] = {
			-- Source: http://www.arcforums.com/forums/air/index.php?/topic/192063-dc-10-lights/   and   https://www.youtube.com/watch?v=EMzBSU-dlSM
            typename = "collection",
            lights = {
                [1] = {
                    typename = "Collection",
                    lights = {
						{
                            typename = "natostrobelight", position = { 3.500, 3.800, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { -8.000, -2.900, 0.000},
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.5,
                        },

						{
                            typename = "Spot", position = { -9.316712, 0.440826, -25.289371 },
                            controller = "VariablePatternStrobe", mode = "2 Flash Long",
							proto = lamp_prototypes.MPS_1, intensity_max = 700.0, period = 0.250, phase_shift = 0.25,
							direction = {azimuth = math.rad(-90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
                        {
                            typename = "Spot", position = { -9.310573, 0.469207, 25.185984 },
                            controller = "VariablePatternStrobe", mode = "2 Flash Long",
							proto = lamp_prototypes.MPS_1, intensity_max = 700.0, period = 0.250, phase_shift = 0.25,
							direction = {azimuth = math.rad(90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
						{
                            typename = "Spot", position = { -25.8, 2.0, 0 },
                            controller = "VariablePatternStrobe", mode = "2 Flash Long",
							proto = lamp_prototypes.MPS_1, intensity_max = 700.0, period = 0.250, phase_shift = 0.25,
							direction = {azimuth = math.rad(180.0), elevation = math.rad(0)}, angle_max = math.rad(160.0), angle_min = math.rad(0),
                        },
                    },
                },
            },
        },

        [WOLALIGHT_FORMATION_LIGHTS] = {
			typename = "collection",
			lights = {
				[1] = {
					typename = "Collection",
					lights = {
						{typename = "argumentlight",argument = 190}, -- Left Position(red)
						{typename = "argumentlight",argument = 191}, -- Right Position(green)
						{typename = "argumentlight",argument = 192}, -- Tail Position (white)
						{
                            typename = "natostrobelight", position = { 3.500, 3.800, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { -8.000, -2.900, 0.000},
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.5,
                        },
					},
				},
			},
		},

		[WOLALIGHT_CABIN_NIGHT] = {
            typename = "collection",
            lights = {
                [1] = {
                    typename = "collection",
                    lights = {
                        {
                            typename = "omnilight", position = {28.5, 1.10, 0.70 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 2.6,
                        },
						{
                            typename = "omnilight", position = {28.5, 1.10, -0.70 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 2.6,
                        },
						{
                            typename = "omnilight", position = {28.3, 0.800, 0.40 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.9,
                        },
						{
                            typename = "omnilight", position = {28.3, 0.800, -0.40 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.9,
                        },
						{
                            typename = "omnilight", position = {27.2, 0.800, 0.40 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 2.1,
                        },
                    },
                },
            },
        },
	},
	},
}

add_aircraft(DC_10)