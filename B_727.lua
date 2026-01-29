-- ===================================================================
-- IMPLEMENTATION NOTES (CONVERSION TO B727-100)
-- ===================================================================
--[[
CONVERSION NOTES FOR BOEING 727-100:

1. DIMENSIONS:
   - Length reduced to 40.59m (Standard -100)
   - Wheelbase shortened (Nose gear moved aft relative to origin)
   - Wing geometry identical (Same span/area as -200)

2. MASS & BALANCE:
   - MTOW: 72,570 kg (Standard 727-100)
   - OEW: 39,800 kg (Typical -100 passenger config)
   - Max Fuel: 24,476 kg (Standard tanks same as -200)

3. ENGINE THRUST (JT8D-7):
   - Total Thrust: 186,825 N (3x 14,000 lbf)
   - Cruising speed slightly lower (Mach 0.82 typical)
   - Specific Fuel Consumption adjusted for earlier JT8D variants

4. FLIGHT CHARACTERISTICS:
   - Higher thrust-to-weight ratio at low weights compared to -200
   - Lower rotational inertia (shorter fuselage)
   - Pitch damping reduced slightly due to shorter moment arm
--]]

B_727 =  {
      
	Name 			= 'B_727',
	DisplayName		= _('B727-100'),
	date_of_introduction= 1964.02,
	Picture 		= "B-727.png",
	Rate 			= "40",
	Shape			= "B_727",
	WorldID			=  WSTYPE_PLACEHOLDER, 
	defFuelRatio    = 0.8,
	singleInFlight 	= true,
        
	shape_table_data 	= 
	{
		{
			file  	 	= 'B_727';
			life  	 	= 20; 
			vis   	 	= 3; 
			desrt    	= 'kc-135-oblomok'; 
			fire  	 	= { 300, 2}; 
			username	= 'B_727';
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
	-- MASS & CAPACITY (727-100)
	-- ============================================================
	M_empty		=	38300,		-- kg (Standard OEW ~87,000 lbs)
	M_nominal	=	65000,		-- kg (Typical Mission Weight)
	M_max		=	72570,		-- kg (MTOW 160,000 lbs)
	M_fuel_max	=	23260,		-- kg (The 727-100 has a smaller center tank, leading to lower total capacity)
	
	-- ============================================================
	-- GEOMETRY & DIMENSIONS
	-- ============================================================
	length		=	40.59,		-- m (133 ft 2 in) - Reduced from 46.68
	height		=	10.36,		-- m (34 ft)
	wing_area	=	153,		-- sq. meters (Same wing)
	wing_span	=	32.92,
	wing_tip_pos = 	{-6.21, -1.45,	16.41},

	
	-- Gear Positions (Adjusted for -100 wheelbase ~53ft/16m)
	nose_gear_pos 	= 	{ 15.61, -3.825,  0.0}, 		-- Nose gear position (ground under center of the axle)
		
	main_gear_pos 	= 	{-0.557, -3.945,  3.1},			-- Main gear position (ground under center of the axle)
														-- automatically mirrored
	
	nose_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (arg 2)
	nose_gear_amortizer_reversal_stroke 	 = -0.235,	-- Full Strut Compression (maximum+ weight on wheels)
	nose_gear_amortizer_normal_weight_stroke = -0.0494,	-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	nose_gear_wheel_diameter				 =  0.709,	-- Diameter of the nose gear wheel (meters)

	main_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (args 4 and 6)
	main_gear_amortizer_reversal_stroke 	 = -0.082,	-- Full Strut Compression (maximum+ weight on wheels)
	main_gear_amortizer_normal_weight_stroke = -0.0172,	-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	main_gear_wheel_diameter 				 =  0.841,	-- Diameter of the main gear wheels (meters)
	
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
	tand_gear_max	=	math.tan(math.rad(78)),
	

	-- ============================================================
	-- PERFORMANCE PARAMETERS (JT8D-7)
	-- ============================================================
	H_max		=	12500,		-- m (~41,000 ft)
	CAS_min		=	58,         -- m/s (Lighter weight = lower stall)
	V_opt		=	242,		-- m/s (Mach 0.82 typical cruise)
	V_take_off	=	68,			-- m/s (~132 kts)
	V_land		=	64,			-- m/s (~125 kts)
	V_max_sea_level	=	180,	-- m/s TAS (350 kts)
	V_max_h			=	255,	-- m/s TAS (Mach 0.88)
	Mach_max	=	0.88,		-- MMO slightly lower on early models
	Vy_max	    =	12.7,       -- m/s (~2,500 ft/min)
	range	    =	4300,       -- km (Standard -100 range)
	
	-- Limits
	Ny_min      	= 	-1.52,    -- [G]
    Ny_max      	= 	2.0,      -- [G]
    Ny_max_e    	= 	2.5,      -- [G]
	bank_angle_max	=	35,
	AOA_take_off	=	math.rad(9.0),
	
	
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
    center_of_mass      = { -0.50, -0.47, 0.0 },				-- [m] CG w.r.t. EDM 3D mesh origin in TsAGI coordinate order

--[[
	MOI and POI (EMPTY configuation) in TsAGI coordinate system.
 
	POI sign check:
	Airliners typically have heavy, podded engines located below the wing (-Y in TsAGI) and
	generally forward of the Center of Gravity (+X), while the empennage/tail (-X)
	structure is high (+Y). The sum of those products should be NEGATIVE.
	
]]
	moment_of_inertia	= {2.7e6, 10.5e6, 9.47e6, -250e3},	-- [kg*m^2] {Roll, Yaw, Pitch, POI}
	
	
	
	-- ============================================================
	-- ENGINE & FUEL (3x Pratt & Whitney JT8D-7)
	-- ============================================================
	-- Thrust (Total 3 Engines):
	-- 3 x 14,000 lbf = 42,000 lbf = ~186,825 N
	thrust_sum_max	= 19050,	-- kgf
	thrust_sum_ab	= 19050,	-- kgf
	
	-- Fuel Consumption:
	-- Cruise Flow: ~3,200 kg/hr = ~0.889 kg/s
	average_fuel_consumption = 0.889,  -- kg/sec
	
	has_afteburner	=	false,
	has_thrustReverser = true,
	
	engines_count	=	3,
	engines_startup_sequence = { 2, 0, 1 },
	engines_nozzles = 
	{
		[1] = 
		{
			pos = 	{-9.9,  0.0,  -2.375},	-- Port engine
			elevation			=	-3.5,	-- 3-4 degree exhaust inclination (negative means exhaust points down)
			azimuth             = 	-2.75,	-- 2.5-3 degree toe-out (negative means thrust vector points away from longitudinal axis; exhaust directed inboard)
			diameter			=	0.752,
			exhaust_length_ab	=	15.24,
			exhaust_length_ab_K	=	0.76,
			smokiness_level     = 	0.08, 	-- JT8Ds are smokey
			engine_number       = 	1,
		}, 
		[2] = 
		{
			pos = 	{-15.25, 0.02, 0.0}, 	-- S-Duct engine
			elevation			=	0,		-- 0 degree exhaust inclination (negative means exhaust points down)
			diameter			=	0.752,
			exhaust_length_ab	=	15.24,
			exhaust_length_ab_K	=	0.76,
			smokiness_level     = 	0.08,
			engine_number       = 	2,
		}, 
		[3] = 
		{
			pos = 	{-9.9,	0.0,	2.375},	-- Starboard engine
			elevation			=	-3.5,	-- 3-4 degree exhaust inclination (negative means exhaust points down)
			azimuth             = 	2.75,	-- 2.5-3 degree toe-out (positive means thrust vector points away from longitudinal axis; exhaust directed inboard)
			diameter			=	0.752,
			exhaust_length_ab	=	15.24,
			exhaust_length_ab_K	=	0.76,
			smokiness_level     = 	0.08,
			engine_number       = 	3,
		}, 
	}, 

	-- ============================================================
	-- SYSTEMS & CREW
	-- ============================================================
	has_speedbrake				=	true,
	has_differential_stabilizer =	false,
	radar_can_see_ground		=	false,   -- Boeing 727-100 sensors cannot detect ground/sea surface units
	flaps_transmission          = "Hydraulic",
    undercarriage_transmission  = "Hydraulic",
	stores_number	=	0,
	tanker_type		=	0,
	flaps_maneuver	=	15/30,	-- Flaps 15 for takeoff; 30 degrees for normal-length field landing (40 degrees possible)
	brakeshute_name	=	0,
	is_tanker		=	false,
	
	crew_size		=	3,
	crew_members = 
	{
		[1] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {17.65, 0.9, -0.44} }, 
		[2] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {17.65, 0.9,  0.44} }, 
		[3] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {15.37, 0.08, 0} }, 
	}, 

	RCS						=	35, 	-- [m^2] Slightly smaller
	detection_range_max		=	30,		-- [km] Distance pilots in this airframe can possibly become aware of other airframes
	IR_emission_coeff		=	1.2,	-- Older, "dirty" engines with low bypass (1:1); hotter exhaust and 3 engines make it brighter than modern narrowbodies.
	IR_emission_coeff_ab	=	0,

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
	}, 

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

	Pylons = {},
	
	Tasks = { aircraft_task(Transport) },	
	DefaultTask = aircraft_task(Nothing),

	-- ============================================================
	-- SFM DATA (Aerodynamics & Engine Tables)
	-- ============================================================
	SFM_Data = {
		aerodynamics = {
			Cy0		= 0.12,		-- Lift at zero AoA
			Mzalfa	= 4.5,		-- Pitch stability
			Mzalfadt = 0.9,		-- Pitch damping
			kjx		= 2.3,		-- Roll inertia
			kjz		= 0.0011,	-- Pitch inertia
			Czbe	= -0.014,	-- Directional stability
			
			cx_gear	= 0.020,	-- Gear drag coefficient
			cx_flap	= 0.08,		-- Triple-slotted flaps create massive drag
			cy_flap	= 0.65,		-- Triple-slotted flaps create massive lift
			cx_brk	= 0.02,		-- Speedbrakes are effective on clean wing
		
			table_data = 
			{
				-- Aerodynamic Drag Polar Table
				-- M: Mach, Cx0: Zero-lift drag, Cya: Normal force coeff, B/B4: Polar shape
				-- Omxmax: Roll rate, Aldop: Max AoA, Cymax: Max Lift
				-- 		 M      Cx0     Cya      B        B4    Omxmax   Aldop   Cymax
				
				-- Low Speed
				[1]  = {0.0,   0.034,  0.090,  0.055,   0.001,   0.35,   13.0,   1.45},
				[2]  = {0.2,   0.034,  0.090,  0.055,   0.001,   0.45,   13.0,   1.45},
				[3]  = {0.4,   0.035,  0.090,  0.055,   0.002,   0.45,   12.5,   1.42},
				
				-- Climb
				[4]  = {0.6,   0.037,  0.078,  0.06,    0.010,   0.50,   15.0,   1.40},
				
				-- Cruise (Mach 0.78 - 0.82 typical)
				[5]  = {0.7,   0.040,  0.050,  0.065,   0.020,   0.50,   14.0,   1.30},
				[6]  = {0.8,   0.042,  0.048,  0.068,   0.030,   0.50,   14.0,   1.05},
				[7]  = {0.84,  0.048,  0.046,  0.070,   0.030,   0.45,   13.0,   1.20},
				
				-- Mach Limit
				[8]  = {0.88,  0.055,  0.042,  0.180,   0.100,   0.70,   11.0,   0.80},
				[9]  = {0.9,   0.100,  0.041,  0.300,   0.200,   0.50,   12.0,   1.00},
				[10] = {1.0,   0.150,  0.040,  0.500,   0.300,   0.30,   8.0,    0.40},
			},
		},

		
		engine = {
			typeng 	= 4,
			type 	= "TurboFan",
			
			Nmg		= 57.1,			-- JT8D-7 N2 ground idle speed (%)
			Nominal_RPM = 12250,	-- JT8D-7 100% speed high pressure turbine (N2)
			Nominal_Fan_RPM = 8600,	-- JT8D-7 100% fan speed (N1)
			MinRUD	= 0,
			MaxRUD	= 1,
			MaksRUD	= 1,
			ForsRUD	= 1,
			
			hMaxEng	= 13.0,     -- [km] Service ceiling ~41,000ft
			dcx_eng	= 0.0090,
			
			-- FUEL FLOW
			-- JT8D-7 is ~0.86 kg/kN/h TSFC @ 9,150 m altitude
			cemax	= 0.092,    -- [kg/kgf/h] scaled
            cefor	= 0.092,
			
			-- Altitude Lapse
			dpdh_m	= 5500,	-- [N/km per engine]
			dpdh_f	= 5500,
			
			table_data = 
			{
				-- THRUST TABLE (3x JT8D-7)
				-- Static: ~186.8 kN Total
				-- CORRECTED: JT8D curve
				[1] = {0.0,    186900,     186900},
				[2] = {0.2,    184000,     184000},
				[3] = {0.4,    180000,     180000},
				[4] = {0.6,    176000,     176000},
				[5] = {0.8,    172000,     172000}, -- Cruise Base (Net ~50kN at FL350)
				[6] = {0.9,    150000,     150000},
			},
		},
	},

	-- ============================================================
	-- DAMAGE MODEL (Unchanged structure, shifted args if needed)
	-- ============================================================
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
		[1] = "B_727-OBLOMOK-WING-R",
		[2] = "B_727-OBLOMOK-WING-L",
	},
	
	-- ============================================================
	-- LIGHTS DEFINITION
	-- ============================================================
	
	--[[
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
	
	-- Boeing 727 - Exterior Lighting: https://www.youtube.com/watch?v=OZC7fiNOL10
	lights_data = { typename = "collection", lights = {
	
        [WOLALIGHT_NAVLIGHTS] = {
            typename = "Collection",
            lights = {
                [1] = {
                    typename = "collection",
                    lights = {
                        {
                            typename = "Spot", position = { -20.558290, 5.764663, 0 },
							direction = {azimuth = math.rad(180.0)},
                            proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(180.0), angle_min = math.rad(170.0),
                        },
						{
							typename = "Omni", position = { -20.558290, 5.764663, 0 },
							proto = lamp_prototypes.ANO_3_Bl, movable = true,
						},
						{
							typename = "Spot", position = { -5.544352, -1.457095, -16.368313 },
							direction = {azimuth = math.rad(-60.0), elevation = math.rad(0)},
							proto = lamp_prototypes.BANO_7M_red, angle_max = math.rad(120.0), angle_min = math.rad(0),
						},
						{
							typename = "Spot", position = { -5.544352, -1.457095, 16.366787 },
							direction = {azimuth = math.rad(60.0), elevation = math.rad(0)},
							proto = lamp_prototypes.BANO_7M_green, angle_max = math.rad(120.0), angle_min = math.rad(0),
						},
						
						{	-- port empennage logo illumination. Source: https://www.jetphotos.com/photo/8520559  and  https://www.jetphotos.com/photo/446298  and  https://www.airplane-pictures.net/photo/1195781/pr-ttp-total-linhas-areas-boeing-727-200f/
                            typename = "Spot",  position = {  -7.0, -2.6, -16.3 },
							direction = {azimuth = math.rad(110.0), elevation = math.rad(-20.0)},
                            proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(25.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.8, movable = true,
                        },
						{	-- starboard empennage logo illumination. Source: https://www.jetphotos.com/photo/8520559   and  https://www.jetphotos.com/photo/446298  and   https://www.airplane-pictures.net/photo/1195781/pr-ttp-total-linhas-areas-boeing-727-200f/
                            typename = "Spot",  position = { -7.0, -2.6, 16.3 },
							direction = {azimuth = math.rad(-110.0), elevation = math.rad(-20.0)},
                            proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(25.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.8, movable = true,
                        },
						
						-- Wing illumination. Source: https://www.youtube.com/watch?v=OZC7fiNOL10
						{
							typename = "Spot",  position = { 6.30, -0.80, -2.80 },
							direction = {azimuth = math.rad(-137.0), elevation = math.rad(1.0)},
							proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0.0),
							cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
						{
							typename = "Spot",  position = { 6.30, -0.80, 2.80 },
							direction = {azimuth = math.rad(137.0), elevation = math.rad(1.0)},
							proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0.0),
							cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
                    },
                },
            },
        },
        [WOLALIGHT_LANDING_LIGHTS] = {
            typename = "Collection",
            lights = {
                [1] = {
                    typename = "collection",
                    lights = {
                        {	-- Nose strut is only for taxi lights.
							typename = "Spot", position = { 15.892764, -2.75, 0 }, argument = 51,
							direction = {azimuth = math.rad(0.0), elevation = math.rad(4.0)},
							proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(40.0), angle_min = math.rad(0),
							cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
						
						-- Inboard takeoff lights (wing root). Source: https://www.youtube.com/watch?v=OZC7fiNOL10
						{
                            typename = "Spot",  position = { 6.7, -1.45, -2.20 }, 
							direction = {azimuth = math.rad(-6.0), elevation = math.rad(3.0)},
                            proto = lamp_prototypes.LFS_P_27_450, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						{
                            typename = "Spot",  position = { 6.7, -1.45, 2.20 },
							direction = {azimuth = math.rad(6.0), elevation = math.rad(3.0)},
                            proto = lamp_prototypes.LFS_P_27_450, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						
						-- Outboard takeoff lights (located within inboard edge of #1 and #6 Kreuger flaps). Source: https://www.youtube.com/watch?v=OZC7fiNOL10
						{
                            typename = "Spot",  position = { 2.744, -1.882, -5.867 },
							direction = {azimuth = math.rad(-4.0), elevation = math.rad(3.0)},
                            proto = lamp_prototypes.LFS_P_27_450, angle_max = math.rad(28.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						{
                            typename = "Spot",  position = { 2.744, -1.882, 5.867 },
							direction = {azimuth = math.rad(4.0), elevation = math.rad(3.0)},
                            proto = lamp_prototypes.LFS_P_27_450, angle_max = math.rad(28.0), angle_min = math.rad(0),
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
                        {	-- Nose strut is only for taxi lights.
							typename = "Spot", position = { 15.892764, -2.75, 0 }, argument = 51,
							direction = {azimuth = math.rad(0.0), elevation = math.rad(4.0)},
							proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(40.0), angle_min = math.rad(0),
							cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
                        
						-- Runway turnoff lights. Source: https://www.airplane-pictures.net/photo/8660/n727vj-kingfisher-airlines-boeing-727-40/
						{
                            typename = "Spot",  position = { 7.6, -0.60, -1.80 }, 
							direction = {azimuth = math.rad(-30.0), elevation = math.rad(4.0)},
                            proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(40.0), angle_min = math.rad(0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						{
                            typename = "Spot",  position = { 7.6, -0.60, 1.80 },
							direction = {azimuth = math.rad(30.0), elevation = math.rad(4.0)},
                            proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(40.0), angle_min = math.rad(0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                    },
                },
            },
        },
		
		[WOLALIGHT_BEACONS] = {			-- For moving around on the ground/taxiing.
            typename = "collection",
            lights = {
                [1] = {
                    typename = "Collection",
                    lights = {
                        {
                            typename = "natostrobelight", position = { 13.01, 1.121, 0.130},		-- Shifted just right of centerline to avoid ice into engine 2.
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 3.30, -2.90, 0.000},
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
                    },
                },
            },
        },
		
        [WOLALIGHT_STROBES] = {			-- For moving around on/near the runway (including airborne).
            typename = "collection",
            lights = {
                [1] = {
                    typename = "Collection",
                    lights = {
                        {
                            typename = "natostrobelight", position = { 13.01, 1.121, 0.130},		-- Shifted just right of centerline to avoid ice into engine 2.
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 3.30, -2.90, 0.000},
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
						
						{
                            typename = "Spot", position = { -5.544352, -1.457095, -16.368313 },
                            controller = "VariablePatternStrobe", mode = "1 Flash",
							proto = lamp_prototypes.MPS_1, intensity_max = 400.0, period = 0.333, phase_shift = 0.25,
							direction = {azimuth = math.rad(-90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
                        {
                            typename = "Spot", position = { -5.544352, -1.457095, 16.366787 },
                            controller = "VariablePatternStrobe", mode = "1 Flash",
							proto = lamp_prototypes.MPS_1, intensity_max = 400.0, period = 0.333, phase_shift = 0.25,
							direction = {azimuth = math.rad(90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
						{
                            typename = "Spot", position = { -20.558290, 5.764663, 0 },
                            controller = "VariablePatternStrobe", mode = "1 Flash",
							proto = lamp_prototypes.MPS_1, intensity_max = 400.0, period = 0.333, phase_shift = 0.25,
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
                            typename = "natostrobelight", position = { 13.01, 1.121, 0.130},		-- Shifted just right of centerline to avoid ice into engine 2.
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 3.30, -2.90, 0.000},
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
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
                            typename = "omnilight", position = {18.3, -0.40, 0.65 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.0,
                        },
						{
                            typename = "omnilight", position = {18.3, -0.40, -0.65 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.0,
                        },
                    },
                },
            },
        },
    		
  			
	}},
}

add_aircraft(B_727)