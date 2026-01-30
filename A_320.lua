-- ===================================================================
-- IMPLEMENTATION NOTES
-- ===================================================================
--[[
FINAL CONVERSION TO AIRBUS A320neo (LEAP-1A)

1. WEIGHTS:
   - MTOW: 79,000 kg (Standard A320neo).
   - OEW: 44,300 kg (Corrected from 42.6t to match reality).
   - Fuel: 19,150 kg (Standard tanks @ 0.803 density).

2. PROPULSION (CFM LEAP-1A26):
   - Total Thrust: 24,596 kgf (241 kN).
   - Startup: Engine 2 (Right) -> Engine 1 (Left).
   - Efficiency: Tuned for ~0.65 kg/s cruise burn.

3. AERODYNAMICS:
   - Cy0: Reduced to 0.05 to prevent "ballooning" on landing.
   - Drag: Optimized for Mach 0.78 cruise.
   - Sharklets: Accounted for in reduced induced drag parameters.
--]]

A_320 =  {
		Name 			= 'A_320',
		DisplayName		= _('A320neo'),
		date_of_introduction  	= 2016.01,
        Picture 		= "A-320.png",
        Rate 			= "40",
        Shape			= "A_320",
        WorldID			=  WSTYPE_PLACEHOLDER,
		defFuelRatio    = 0.8,
		singleInFlight 	= true,

	shape_table_data 	=
	{
		{
			file  	 	= 'A_320';
			life  	 	= 20;
			vis   	 	= 3;
			desrt    	= 'kc-135-oblomok';
			fire  	 	= { 300, 2};
			username	= 'A_320';
			index       =  WSTYPE_PLACEHOLDER;
			classname   = "lLandPlane";
			positioning = "BYNORMAL";
		},
		{
			name  		= "kc-135-oblomok";
			file  		= "kc-135-oblomok";
			fire  		= { 240, 2};
		},
	},

	mapclasskey 		= "P0091000029",
	attribute  			= {wsType_Air, wsType_Airplane, wsType_Cruiser, WSTYPE_PLACEHOLDER, "Transports",},
	Categories 			= {},

	-- ============================================================
	-- MASS & CAPACITY (A320neo)
	-- ============================================================
	M_empty			= 44300,	-- [kg] (Standard OEW)
	M_nominal		= 73500,	-- [kg] (Typical Operating Weight)
	M_max			= 79000,	-- [kg] (MTOW)
	M_fuel_max		= 19158,	-- [kg] (Standard Tanks ~23,860 L)

	-- ============================================================
	-- GEOMETRY
	-- ============================================================
	length 			= 37.57,	-- [m]
	height 			= 11.76,	-- [m]
	wing_area		= 122.6,	-- [m^2] 
	wing_span		= 35.80,	-- [m] (With Sharklets)

	wing_tip_pos 	= {-4.3, 0.34,	16.59}, -- +/- 17.9m span

	-- LANDING GEAR
	nose_gear_pos 	= { 12.135, -4.23,  0.0}, 		-- Nose gear position (ground under center of the axle)

	main_gear_pos 	= {-0.375,  -4.146, 3.7834},	-- Main gear position (ground under center of the axle)
													-- automatically mirrored

	nose_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (arg 2)
	nose_gear_amortizer_reversal_stroke 	 = -0.237,	-- Full Strut Compression (maximum+ weight on wheels)
	nose_gear_amortizer_normal_weight_stroke = -0.1343,	-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	nose_gear_wheel_diameter				 =  1.002,	-- Diameter of the nose gear wheel (meters)

	main_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (args 4 and 6)
	main_gear_amortizer_reversal_stroke 	 = -0.082,	-- Full Strut Compression (maximum+ weight on wheels)
	main_gear_amortizer_normal_weight_stroke = -0.0246,	-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	main_gear_wheel_diameter 				 =  1.287,	-- Diameter of the main gear wheels (meters)

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
	tand_gear_max	=	math.tan(math.rad(75)), 	-- Max steering angle

	-- ============================================================
	-- PERFORMANCE
	-- ============================================================
	H_max 			= 12130,  	-- [m] (39,800 ft)
	CAS_min 		= 64,  		-- [m/s TAS] (Stall ~125 kts)
	V_opt			= 234,		-- [m/s TAS] (Mach 0.78 Cruise)
	V_take_off		= 77,		-- [m/s TAS] (Vr)
	V_land			= 68,		-- [m/s TAS] (Vref)
	V_max_sea_level	= 196,		-- [m/s TAS] Set to max dive speed (Vd = ~381 KCAS) since DCS was magic restricting climb due to powerful engines
	V_max_h			= 244,		-- [m/s TAS] (MMO Mach 0.82)
	Mach_max 		= 0.82,		-- MMO
	Vy_max 			= 12.7,     -- [m/s] (Climb rate ~2800 fpm)
	range 			= 6500,		-- [km]

	-- Limits
	Ny_min			= -1.52,	-- [G]
	Ny_max			= 2.0,		-- [G]
	Ny_max_e		= 2.5,		-- [G]
	bank_angle_max 	= 35,		-- [degrees]
	AOA_take_off 	= math.rad(10),	-- [radians]

	-- ===================================================================
    -- INERTIA & CG (Airbus A320neo)
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
    center_of_mass      = {2.85, -0.60, 0.0},				-- [m] CG w.r.t. EDM 3D mesh origin in TsAGI coordinate order

--[[
	MOI and POI (EMPTY configuation) in TsAGI coordinate system.
 
	POI sign check:
	Airliners typically have heavy, podded engines located below the wing (-Y in TsAGI) and
	generally forward of the Center of Gravity (+X), while the empennage/tail (-X)
	structure is high (+Y). The sum of those products should be NEGATIVE.
	
]]
	moment_of_inertia	= {4.45e6, 10e6, 9.02e6, -110e3},	-- [kg*m^2] {Roll, Yaw, Pitch, POI}

	-- ============================================================
	-- ENGINES (2x CFM LEAP-1A26)
	-- ============================================================
	engines_count	=	2,

	-- Thrust: 2x 27,120 lbf = 54,240 lbf = 241.2 kN = ~24,596 kgf
	thrust_sum_max	= 24596,	-- [kgf] Total thrust
	thrust_sum_ab	= 24596,	-- [kgf] Total thrust w/afterburner

	-- Fuel Consumption
	-- (Cruise fuel flow ~2,400 kg/h / 0.65 kg/s total for LEAP engines)
	average_fuel_consumption = 0.65, 	-- [kg/s] Total fuel consumption rate

	has_afteburner 		= false,
	has_thrustReverser 	= true,

	-- Startup: Right (2/1) then Left (1/0)
	engines_startup_sequence = { 1, 0 },

	engines_nozzles =
	{
		[1] =
		{
			pos 	= {0.93, -2.357, -5.801},
			elevation			= -3.6,	-- 3.6 degree exhaust depression (negative means exhaust points down)
			azimuth             = 1.5,	-- 1.5 degree toe-in (positive means thrust vector points toward longitudinal axis; exhaust points away)
			diameter 			= 1.71,
			exhaust_length_ab	= 2.5,
			exhaust_length_ab_K	= 0.76,
			smokiness_level     = 0.005, -- LEAP is very clean
			engine_number       = 1,
		},
		[2] =
		{
			pos 	= {0.93, -2.357, 5.801},
			elevation			= -3.6,	-- 3.6 degree exhaust depression (negative means exhaust points down)
			azimuth             = -1.5,	-- 1.5 degree toe-in (negative means thrust vector points toward longitudinal axis; exhaust points away)
			diameter 			= 1.71,
			exhaust_length_ab	= 2.5,
			exhaust_length_ab_K	= 0.76,
			smokiness_level     = 0.005,
			engine_number       = 2,
		},
	},

	-- ============================================================
	-- SYSTEMS & CREW
	-- ============================================================
	has_speedbrake				= true,
	has_differential_stabilizer = false,
	radar_can_see_ground		= false,
	flaps_transmission          = "Hydraulic",
	undercarriage_transmission  = "Hydraulic",
	stores_number				= 0,
	tanker_type					= 0,
	is_tanker					= false,
	brakeshute_name				= 0,

	flaps_maneuver		= 0.25,	-- Corresponds to CONF 1+F
	RCS					= 65,	-- [m^2]
	detection_range_max	= 30,	-- [km] Distance pilots in this airframe can possibly become aware of other airframes
	IR_emission_coeff	= 0.90, -- Very high bypass (12:1) shrouds the core; cool exhaust reduces intensity despite higher mass flow than Su-27.
	IR_emission_coeff_ab= 0,

	crew_size		= 2, -- 2 Pilots
	crew_members	=
	{
		[1] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {14.6, 0.4, -0.47} },
		[2] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {14.6, 0.4,  0.47} },
	},

	fires_pos =
	{
		[1] = 	{-0.138,	-0.79,	0},
		[2] = 	{-0.138,	-0.79,	5.741},
		[3] = 	{-0.138,	-0.79,	-5.741},
		[4] = 	{-0.82,		0.265,	2.774},
		[5] = 	{-0.82,		0.265,	-2.774},
		[6] = 	{-0.82,		0.255,	4.274},
		[7] = 	{-0.82,		0.255,	-4.274},
		[8] = 	{-0.347,	-1.875,	8.138},
		[9] = 	{-0.347,	-1.875,	-8.138},
		[10] = 	{-5.024,	-1.353,	13.986},
		[11] = 	{-5.024,	-1.353,	-13.986},
	}, -- end of fires_pos

	CanopyGeometry = {
        azimuth = {-110.0, 110.0},
        elevation = {-30.0, 60.0},
    },

	Failures = {
		{ id = 'asc', 		label = _('ASC'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'autopilot', label = _('AUTOPILOT'), enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'hydro',  	label = _('HYDRO'), 	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'l_engine',  label = _('L-ENGINE'), 	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'r_engine',	label = _('R-ENGINE'), 	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
	},

    HumanRadio = {
		frequency = 127.5,
		editable = true,
		minFrequency = 118.000,
		maxFrequency = 137.000,
		modulation = MODULATION_AM
	},

	Pylons = { },
	Tasks = { aircraft_task(Transport) },
	DefaultTask = aircraft_task(Nothing),

	-- ============================================================
	-- SFM DATA
	-- ============================================================
	SFM_Data = {
		aerodynamics = {
			Cy0     = 0.20,     -- Lift coefficient at zero AoA
            Mzalfa  = 4.8,		-- Pitch stability / Lift slope / Coefficient of longitudinal static stability (C_m_alpha)
            Mzalfadt = 1.0,     -- Pitch damping
            kjx     = 2.8,      -- Roll inertia
            kjz     = 0.0012,	-- Pitch inertia
            Czbe    = -0.018,	-- Directional stability

            cx_gear = 0.020,	-- Gear drag coefficient
            cx_flap = 0.055,	-- Flaps drag coefficient
            cy_flap = 0.90,		-- Flaps lift coefficient
            cx_brk  = 0.05,		-- Speedbrake drag

            table_data = {
				-- Aerodynamic Drag Polar Table
				-- M: Mach, Cx0: Zero-lift drag, Cya: Normal force coeff, B/B4: Polar shape
				-- Omxmax: Roll rate, Aldop: Max AoA, Cymax: Max Lift
				-- 		 M      Cx0     Cya      B       B4    Omxmax   Aldop   Cymax

				-- Low Speed
				[1]  = {0.0,   0.015,  0.098,  0.030,  0.001,   0.30,   13,     1.45},
				[2]  = {0.2,   0.015,  0.098,  0.030,  0.001,   0.30,   13,     1.45},
				[3]  = {0.4,   0.016,  0.098,  0.030,  0.002,   0.30,   12.5,   1.45},

				-- Climb
				[4]  = {0.6,   0.018,  0.099,  0.035,  0.01,    0.26,   15,     1.40},

				-- Cruise (Mach 0.78 - 0.82 typical)
				[5]  = {0.7,   0.02,   0.100,  0.040,  0.02,    0.26,   14,     1.30},
				[6]  = {0.8,   0.022,  0.100,  0.043,  0.03,    0.26,   14.0,   1.05},
				[7]  = {0.84,  0.028,  0.095,  0.045,  0.03,    0.26,   13,     1.20},

				-- Mach Limit
				[8]  = {0.88,  0.05,   0.090,  0.17,   0.100,   0.22,   11.0,   0.80},
				[9]  = {0.9,   0.09,   0.082,  0.29,   0.200,   0.20,   12,     1.00},
				[10] = {1.0,   0.14,   0.075,  0.49,   0.300,   0.15,   8.0,    0.40},
			},
		},

		engine = {
			typeng 		= 4,
			type 		= "TurboFan",

			Nmg			= 58.5,
			Nominal_RPM = 16645.0,	-- N2 100%
			Nominal_Fan_RPM = 3851.0, -- N1 100%
			MinRUD		= 0,
			MaxRUD		= 1,
			MaksRUD		= 1,
			ForsRUD		= 1,

			hMaxEng		= 13.5,
			dcx_eng		= 0.0075,

			-- FUEL FLOW
			cemax		= 0.55,     -- kg/kgf/h scaled	
			cefor		= 0.55,     -- kg/kgf/h scaled	

			-- Altitude lapse
			dpdh_m		= 12000,	-- [N/km per engine]
			dpdh_f		= 12000,

			table_data = {
				--      M      Pmax (N)   Pmax_ab (N)
				-- THRUST TABLE (2x CFM LEAP-1A26)
				-- Re-tuned for "High Bypass" Momentum Drag characteristics.

				[1] = {0.0,    241200,     241200}, -- Static: 100% (241 kN)
				[2] = {0.2,    238000,     238000}, -- Takeoff/Climb out
				[3] = {0.4,    230000,     230000},
				[4] = {0.6,    215000,     215000}, -- Climb profile
				[5] = {0.7,    205000,     205000},

				-- CRUISE REGIME
				-- Significant drop introduced here to match real-world "Net Thrust"
				[6] = {0.78,   195000,     195000}, -- Cruise Base (~80% of static)
				[7] = {0.82,   170000,     170000}, -- MMO Wall (Thrust drops off fast)
				[8] = {0.9,    120000,     120000}, -- Transonic Drag Rise (Engine chokes)
			},
		},
	},

	--damage , index meaning see in  Scripts\Aircrafts\_Common\Damage.lua
	Damage = {
	[0]  = {critical_damage = 5,  args = {146}},
	[1]  = {critical_damage = 3,  args = {296}},
	[2]  = {critical_damage = 3,  args = {297}},
	[3]  = {critical_damage = 8,  args = {65}},
	[4]  = {critical_damage = 2,  args = {298}},
	[5]  = {critical_damage = 2,  args = {301}},
	[7]  = {critical_damage = 2,  args = {249}},
	[8]  = {critical_damage = 3,  args = {265}},
	[9]  = {critical_damage = 3,  args = {154}},
	[10] = {critical_damage = 3,  args = {153}},
	[11] = {critical_damage = 1,  args = {167}},
	[12] = {critical_damage = 1,  args = {161}},
	[13] = {critical_damage = 2,  args = {169}},
	[14] = {critical_damage = 2,  args = {163}},
	[15] = {critical_damage = 2,  args = {267}},
	[16] = {critical_damage = 2,  args = {266}},
	[17] = {critical_damage = 2,  args = {168}},
	[18] = {critical_damage = 2,  args = {162}},
	[20] = {critical_damage = 2,  args = {183}},
	[23] = {critical_damage = 5,  args = {223}},
	[24] = {critical_damage = 5,  args = {213}},
	[25] = {critical_damage = 2,  args = {226}},
	[26] = {critical_damage = 2,  args = {216}},
	[29] = {critical_damage = 5,  args = {224}, deps_cells = {23, 25}},
	[30] = {critical_damage = 5,  args = {214}, deps_cells = {24, 26}},
	[35] = {critical_damage = 6,  args = {225}, deps_cells = {23, 29, 25, 37}},
	[36] = {critical_damage = 6,  args = {215}, deps_cells = {24, 30, 26, 38}},
	[37] = {critical_damage = 2,  args = {228}},
	[38] = {critical_damage = 2,  args = {218}},
	[39] = {critical_damage = 2,  args = {244}, deps_cells = {53}},
	[40] = {critical_damage = 2,  args = {241}, deps_cells = {54}},
	[43] = {critical_damage = 2,  args = {243}, deps_cells = {39, 53}},
	[44] = {critical_damage = 2,  args = {242}, deps_cells = {40, 54}},
	[51] = {critical_damage = 2,  args = {240}},
	[52] = {critical_damage = 2,  args = {238}},
	[53] = {critical_damage = 2,  args = {248}},
	[54] = {critical_damage = 2,  args = {247}},
	[56] = {critical_damage = 2,  args = {158}},
	[57] = {critical_damage = 2,  args = {157}},
	[59] = {critical_damage = 3,  args = {148}},
	[61] = {critical_damage = 2,  args = {147}},
	[82] = {critical_damage = 2,  args = {152}},
	},

	DamageParts =
	{
		[1] = "A_320-OBLOMOK-WING-R", -- wing R
		[2] = "A_320-OBLOMOK-WING-L", -- wing L
--		[3] = "kc-135-oblomok-noise", -- nose
--		[4] = "kc-135-oblomok-tail-r", -- tail
--		[5] = "kc-135-oblomok-tail-l", -- tail
	},

	-- ============================================================
	-- LIGHTS
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
                            typename = "Spot", position = { -20.2, 0.70, 0 },
							direction = {azimuth = math.rad(180.0)}, -- argument = 192,
                            proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(120.0), angle_min = math.rad(0),
                        },
						{
							typename = "Omni", position = { -20.2, 0.70, 0 },
							proto = lamp_prototypes.ANO_3_Bl, movable = true,
						},
                        {
                            typename = "Spot", position = { -3.375624, 0.542083, -16.727669 },
							direction = {azimuth = math.rad(-60.0), elevation = math.rad(0)}, -- argument = 190,
                            proto = lamp_prototypes.BANO_7M_red, angle_max = math.rad(120.0), angle_min = math.rad(0),
                        },
                        {
                            typename = "Spot", position = { -3.374262, 0.542083, 16.712601 },
							direction = {azimuth = math.rad(60.0), elevation = math.rad(0)}, -- argument = 191,
                            proto = lamp_prototypes.BANO_7M_green, angle_max = math.rad(120.0), angle_min = math.rad(0),
                        },

						{	-- port empennage logo illumination. Source: https://www.theseus.fi/bitstream/handle/10024/506067/Korhonen_Soila.pdf
                            typename = "Spot",  position = { -17.0, 0.7, -3.0 },
							direction = {azimuth = math.rad(70.0), elevation = math.rad(-55.0)},
                            proto = lamp_prototypes.FR_100, angle_max = math.rad(80.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, power_up_t = 0.2, cool_down_t = 0.2, movable = true,
                        },
						{	-- starboard empennage logo illumination. Source: https://www.theseus.fi/bitstream/handle/10024/506067/Korhonen_Soila.pdf
                            typename = "Spot",  position = { -17.0, 0.7, 3.0 },
							direction = {azimuth = math.rad(-70.0), elevation = math.rad(-55.0)},
                            proto = lamp_prototypes.FR_100, angle_max = math.rad(80.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, power_up_t = 0.2, cool_down_t = 0.2, movable = true,
                        },

						-- Wing illumination. Source: https://www.theseus.fi/bitstream/handle/10024/506067/Korhonen_Soila.pdf
						{
                            typename = "Spot",  position = { 10.000, -0.500, -1.90 },
							direction = {azimuth = math.rad(-145.0), elevation = math.rad(0.0)},
                            proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.35, movable = true,
                        },
						{
                            typename = "Spot",  position = { 10.000, -0.500, 1.90 },
							direction = {azimuth = math.rad(145.0), elevation = math.rad(0.0)},
                            proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.35, movable = true,
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
                            typename = "Spot",  position = { 16.000, -2.500, 0.150 },
							direction = {azimuth = math.rad(0.0), elevation = math.rad(5.0)}, argument = 51,
                            proto = lamp_prototypes.LFS_P_27_600, angle_max = math.rad(25.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 0.000, -2.600, -3.00 },
							direction = {azimuth = math.rad(-10.0), elevation = math.rad(4.0)},
                            proto = lamp_prototypes.LFS_P_27_600, angle_max = math.rad(20.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 0.000, -2.600, 3.00 },
							direction = {azimuth = math.rad(10.0), elevation = math.rad(4.0)},
                            proto = lamp_prototypes.LFS_P_27_600, angle_max = math.rad(20.0), angle_min = math.rad(0),
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
                            typename = "Spot",  position = { 11.000, -2.500, 0.150 },
							direction = {elevation = math.rad(8.0)}, argument = 51,
                            proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(40), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 11.000, -2.600, -0.150 },
							direction = {azimuth = math.rad(-45.0), elevation = math.rad(8.0)},
                            proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(50), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 11.000, -2.600, 0.150 },
							direction = {azimuth = math.rad(45.0), elevation = math.rad(8.0)},
                            proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(50), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                    },
                },
            },
        },
        [WOLALIGHT_BEACONS] = {			-- For moving around on the ground/taxiing.
			-- Source: https://www.theseus.fi/bitstream/handle/10024/506067/Korhonen_Soila.pdf
            typename = "collection",
            lights = {
                [1] = {
                    typename = "Collection",
                    lights = {
                        {
                            typename = "natostrobelight", position = { -0.74, 1.950, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 1.00, -2.80, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.5,
                        },
                    },
                },
            },
        },

		[WOLALIGHT_STROBES] = {			-- For moving around on/near the runway (including airborne).
			-- Source: https://www.theseus.fi/bitstream/handle/10024/506067/Korhonen_Soila.pdf
            typename = "collection",
            lights = {
                [1] = {
                    typename = "Collection",
                    lights = {
                        {
                            typename = "natostrobelight", position = { -0.74, 1.950, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 1.00, -2.80, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.5,
                        },

						{
                            typename = "Spot", position = { -3.375624, 0.542083, -16.727669 },
                            controller = "VariablePatternStrobe", mode = "2 Flash Long",
							proto = lamp_prototypes.MPS_1, intensity_max = 500.0, period = 0.250, phase_shift = 0.25,
							direction = {azimuth = math.rad(-90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
                        {
                            typename = "Spot", position = { -3.374262, 0.542083, 16.712601 },
                            controller = "VariablePatternStrobe", mode = "2 Flash Long",
							proto = lamp_prototypes.MPS_1, intensity_max = 500.0, period = 0.250, phase_shift = 0.25,
							direction = {azimuth = math.rad(90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
						{
                            typename = "Spot", position = { -20.2, 0.70, 0 },
                            controller = "VariablePatternStrobe", mode = "2 Flash Long",
							proto = lamp_prototypes.MPS_1, intensity_max = 500.0, period = 0.250, phase_shift = 0.25,
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
                            typename = "natostrobelight", position = { -0.74, 1.950, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 1.00, -2.80, 0.000 },
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
                            typename = "omnilight", position = {15.5, 0.100, 0.5 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.0,
                        },
						{
                            typename = "omnilight", position = {15.5, 0.100, -0.5 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.0,
                        },
						{
                            typename = "omnilight", position = {15.25, 0.650, 0.35 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.0,
                        },
						{
                            typename = "omnilight", position = {15.25, 0.650, -0.35 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.0,
                        },
                    },
                },
            },
        },
	},
	},
}

add_aircraft(A_320)