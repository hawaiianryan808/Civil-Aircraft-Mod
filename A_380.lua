-- ===================================================================
-- IMPLEMENTATION NOTES
-- ===================================================================
--[[
FINAL CONVERSION TO AIRBUS A380-800 (REAL WORLD SPEC)

1. DIMENSIONS (RESTORED):
   - Wingspan: 79.75 m
   - Length: 72.72 m
   - Height: 24.09 m
   - Wing Area: 845 m² (Verified).

2. AERODYNAMICS:
   - Cy0 (Zero-Lift Coeff): Increased to 0.15. 
     (Previous 0.02 was too low for a high-camber superjumbo wing).
   - Pitch Stability (Mzalfa): High (6.0) to simulate heavy damping.
   - Roll Inertia (kjx): High (3.75) for 80m span.

3. PROPULSION (Rolls-Royce Trent 972):
   - Thrust: 4 × 356.81 kN = 1,427 kN / ~145,500 kgf for Trent 972
   - Fuel Flow: 4.7 kg/s cruise average (~17t/hr).
   - OEW: 276,800 kg.
   - MTOW: 575,000 kg.
--]]

A_380 =  {
    Name 				= 'A_380',
    DisplayName			= _('A380-800'),
	date_of_introduction= 2007.10,
    Picture 			= "A-380.png",
    Rate 				= "40",
    Shape				= "A_380",
    WorldID				= WSTYPE_PLACEHOLDER,
	defFuelRatio    	= 0.8,
    singleInFlight 		= true,

    shape_table_data 	=
    {
        {
            file  	 	= 'A_380';
            life  	 	= 20;
            vis   	 	= 3;
            desrt    	= 'kc-135-oblomok';
            fire  	 	= { 300, 2};
            username	= 'A_380';
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

    Categories = {},

    -- ===================================================================
    -- MASS AND CAPACITY PARAMETERS
    -- ===================================================================
    M_empty     = 276800,   -- [kg] (OEW)
    M_nominal   = 485000,   -- [kg] (Typical Op Weight)
    M_max       = 575000,   -- [kg] (MTOW)
    M_fuel_max  = 254000,   -- [kg] (Standard Capacity)

    -- ===================================================================
    -- PERFORMANCE AND SPEEDS
    -- ===================================================================
    H_max       = 13100,    -- [m] Max altitude (43,000 ft)
    range       = 15200,    -- [km] Max range

    Mach_max    = 0.89,     -- MMO
    V_max_sea_level = 175,  -- [m/s TAS] (340 KCAS)
    V_max_h     = 263.4,    -- [m/s TAS]
    CAS_min     = 56,       -- [m/s TAS] (Stall clean)

    V_opt       = 250,      -- [m/s TAS] (Mach 0.85 Cruise)
    V_take_off  = 77,     	-- [m/s TAS] (Vr)
    V_land      = 69,     	-- [m/s TAS] (Vref)

    Vy_max      = 9,      	-- [m/s] (Initial heavy climb)

    Ny_min      = -1.52,    -- [G]
    Ny_max      = 2.0,      -- [G]
    Ny_max_e    = 2.5,      -- [G]
    bank_angle_max = 25,    -- [degrees] (FBW limited)
    AOA_take_off = math.rad(8),	-- [degrees] Takeoff AoA

    -- ===================================================================
    -- ENGINE PARAMETERS (4x Trent 972)
    -- ===================================================================
    -- Total thrust 4 × 356.81 kN = 1,427 kN / ~145,500 kgf
    thrust_sum_max  = 145500, -- [kgf] Total thrust
    thrust_sum_ab   = 145500, -- [kgf] Total thrust w/afterburner

	-- Cruise fuel flow for Trent engines.
    average_fuel_consumption = 4.7, -- [kg/sec] total

    -- ===================================================================
    -- DIMENSIONS
    -- ===================================================================
	-- Some of these dimensions are artificially reduced because DCS's
	-- spawn volume limits are stupid.
    wing_area   = 845,		-- [m^2]
    wing_span   = 65.0,		-- [m] Limited because DCS is stupid (real-world: 79.75m)
    length      = 65.0,		-- [m] Limited because DCS is stupid (real-world: 72.72m)
    height      = 12.4,		-- [m] Limited because DCS is stupid (real-world: 24.09m)

    has_afteburner      		= false,
    has_speedbrake      		= true,
    has_thrustReverser  		= true,
    has_differential_stabilizer = false,
    radar_can_see_ground 		= false,
	flaps_transmission          = "Hydraulic",
    undercarriage_transmission  = "Hydraulic",
	flaps_maneuver				= 0.24,		-- Corresponds to CONF 1+F

    crew_size   				= 3,
    RCS         				= 140,		-- [m^2] Radar Cross Section
	detection_range_max			= 30,		-- [km] Distance pilots in this airframe can possibly become aware of other airframes
    IR_emission_coeff 			= 4.2,		-- While efficient/cool per unit of thrust, the 1.2+ million lbs of total thrust generates a massive IR blooming effect.
    IR_emission_coeff_ab 		= 0,
    engines_count 				= 4,

	wing_tip_pos  = {-13.37, 1.588, 39.69}, -- Fits 79.75m span

    -- Gear Configuration
	nose_gear_pos 	= 	{ 31.548, -5.856, -0.0056}, 	-- Nose gear position (ground under center of the axle)

	main_gear_pos 	= 	{-1.45,   -6.02,   7.631},		-- Main gear position (ground under center of the axle)
														-- automatically mirrored

	nose_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (arg 2)
	nose_gear_amortizer_reversal_stroke 	 = -0.4192,	-- Full Strut Compression (maximum+ weight on wheels)
	nose_gear_amortizer_normal_weight_stroke = -0.173,	-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	nose_gear_wheel_diameter				 =  1.371,	-- Diameter of the nose gear wheel (meters)

	main_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (args 4 and 6)
	main_gear_amortizer_reversal_stroke 	 = -0.144,	-- Full Strut Compression (maximum+ weight on wheels)
	main_gear_amortizer_normal_weight_stroke = -0.0646,	-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	main_gear_wheel_diameter 				 =  1.455,	-- Diameter of the main gear wheels (meters)

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
	tand_gear_max	=	math.tan(math.rad(70)),


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
    center_of_mass      = { 2.01, -1.0, 0.0 },				-- [m] CG w.r.t. EDM 3D mesh origin in TsAGI coordinate order

--[[
	MOI and POI (EMPTY configuation) in TsAGI coordinate system.
 
	POI sign check:
	Airliners typically have heavy, podded engines located below the wing (-Y in TsAGI) and
	generally forward of the Center of Gravity (+X), while the empennage/tail (-X)
	structure is high (+Y). The sum of those products should be NEGATIVE.
	
]]
	moment_of_inertia	= {138e6, 234e6, 211e6, -1.8e6},	-- [kg*m^2] {Roll, Yaw, Pitch, POI}



    -- ===================================================================
    -- ENGINE NOZZLES
    -- ===================================================================
	engines_startup_sequence = { 0, 1, 2, 3 }, -- Left to Right
    engines_nozzles = {
        [1] = {		-- Left outboard
			pos = {-1.227, -1.9785, -25.374},
			elevation			= -2.5,	-- 2.5 degree exhaust depression (negative means exhaust points down)
			azimuth             = 2.0,	-- 2 degree toe-in (positive means thrust vector points toward longitudinal axis; exhaust points away)
			diameter 			= 1.522,
			exhaust_length_ab 	= 7.62,
			exhaust_length_ab_K = 0.76,
			smokiness_level 	= 0.01,
			engine_number 	= 1,
		},
        [2] = {		-- Left inboard
			pos = {6.348, -3.072, -14.582},
			elevation			= -3.0,	-- 3.0 degree exhaust depression (negative means exhaust points down)
			azimuth             = 1.5,	-- 1.5 degree toe-in (positive means thrust vector points toward longitudinal axis; exhaust points away)
			diameter 			= 1.522,
			exhaust_length_ab 	= 7.62,
			exhaust_length_ab_K = 0.76,
			smokiness_level 	= 0.01,
			engine_number 		= 2,
		},
        [3] = {		-- Right inboard
			pos = {6.348, -3.072, 14.582},
			elevation			= -3.0,	-- 3.0 degree exhaust depression (negative means exhaust points down)
			azimuth             = -1.5,	-- 1.5 degree toe-in (negative means thrust vector points toward longitudinal axis; exhaust points away)
			diameter 			= 1.522,
			exhaust_length_ab 	= 7.62,
			exhaust_length_ab_K = 0.76,
			smokiness_level 	= 0.01,
			engine_number 		= 3,
		},
        [4] = {		-- Right outboard
			pos = {-1.227, -1.9785, 25.374},
			elevation			= -2.5,	-- 2.5 degree exhaust depression (negative means exhaust points down)
			azimuth             = -2.0,	-- 2 degree toe-in (negative means thrust vector points toward longitudinal axis; exhaust points away)
			diameter 			= 1.522,
			exhaust_length_ab 	= 7.62,
			exhaust_length_ab_K = 0.76,
			smokiness_level 	= 0.01,
			engine_number 		= 4,
		},
    },

    crew_members = {
        [1] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {32.9, 0.986, -0.50} },
        [2] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {32.9, 0.986, 0.50} },
        [3] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {29.9, 0.986, 0} },
    },

    fires_pos = {
        [1] = 	{-0.138,	-0.79,	0},
        [2] = 	{-0.138,	-0.79,	5.741},
        [3] = 	{-0.138,	-0.79,	-5.741},
        [4] = 	{-0.82,		 0.265,	2.774},
        [5] = 	{-0.82,		 0.265,	-2.774},
        [6] = 	{-0.82,		 0.255,	4.274},
        [7] = 	{-0.82,		 0.255,	-4.274},
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
        -- Updated for 4 Independent Engines
        { id = 'engine_1',  label = _('Engine 1 (L-Out)'),  enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'engine_2',  label = _('Engine 2 (L-In)'),   enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'engine_3',  label = _('Engine 3 (R-In)'),   enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'engine_4',  label = _('Engine 4 (R-Out)'),  enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },

        -- Standard Systems
        { id = 'asc',       label = _('ASC'),       enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'autopilot', label = _('AUTOPILOT'), enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'hydro',     label = _('HYDRO'),     enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
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

    -- ===================================================================
    -- SFM AERODYNAMICS & ENGINE SIMULATION
    -- ===================================================================
    SFM_Data = {
        aerodynamics = {
            -- Control authority parameters
            Cy0         = 0.15,     -- 0 degree AoA lift
            Mzalfa      = 6.0,		-- Pitch stability
            Mzalfadt    = 1.1,      -- Pitch damping
            kjx         = 3.75,		-- High roll inertia
            kjz         = 0.0025,   -- Pitch inertia
            Czbe        = -0.010,   -- Directional stability

            -- Drag coefficients (Large Surface Areas)
            cx_gear     = 0.055,	-- Gear drag coefficient
            cx_flap     = 0.07,		-- Flaps drag coefficient
            cy_flap     = 0.90,		-- Flaps lift coefficient
            cx_brk      = 0.15,		-- Speedbrake drag

            table_data = {
				-- Aerodynamic Drag Polar Table
				-- M: Mach, Cx0: Zero-lift drag, Cya: Normal force coeff, B/B4: Polar shape
				-- Omxmax: Roll rate, Aldop: Max AoA, Cymax: Max Lift
				-- 		 M      Cx0     Cya       B       B4     Omxmax  Aldop    Cymax
				-- REVISION: Slightly lower induced drag for sharklets

				-- Low Speed
				[1]  = {0.0,   0.018,  0.095,   0.025,   0.001,   0.35,   13,     1.45},
				[2]  = {0.2,   0.018,  0.095,   0.025,   0.001,   0.45,   13,     1.45},
				[3]  = {0.4,   0.019,  0.095,   0.025,   0.002,   0.45,   12.5,   1.45},

				-- Climb
				[4]  = {0.6,   0.021,  0.093,  0.03,     0.01,    0.50,   15,     1.40},

				-- Cruise (Mach 0.82 - 0.86 typical)
				[5]  = {0.7,   0.024,  0.092,   0.035,   0.02,    0.50,   14,     1.30},
				[6]  = {0.8,   0.026,  0.091,   0.038,   0.03,    0.50,   14.0,   1.05},
				[7]  = {0.84,  0.032,  0.090,   0.04,    0.03,    0.45,   13,     1.20},

				-- Mach Limit
				[8]  = {0.88,  0.055,  0.105,   0.16,    0.100,   0.7,    11.0,   0.80},
				[9]  = {0.9,   0.12,   0.087,   0.28,    0.200,   0.5,    12,     1.00},
				[10] = {1.0,   0.35,   0.085,   0.48,    0.300,   0.3,    8.0,    0.40},

			--[[
                -- 		 M      Cx0     Cya      B        B4     Omxmax   Aldop   Cymax
                
                -- Low speed / takeoff / landing
				[1]  = {0.0,   0.016,  0.070,  0.065,   0.003,   0.35,    13.5,   5.00},
				[2]  = {0.1,   0.017,  0.160,  0.066,   0.006,   0.35,    13.5,   5.00},
				[3]  = {0.2,   0.018,  0.155,  0.068,   0.006,   0.35,    13.5,   4.50},
				[4]  = {0.3,   0.018,  0.145,  0.070,   0.006,   0.35,    13.5,   3.80},
				[5]  = {0.4,   0.019,  0.120,  0.072,   0.011,   0.30,    13.0,   1.90},
				
				-- Climb
				[6]  = {0.6,   0.021,  0.097,  0.078,   0.018,   0.28,    12.5,   1.34},
				[7]  = {0.7,   0.023,  0.093,  0.088,   0.026,   0.25,    12.0,   1.30},
				
				-- Cruise (M0.82-0.85)
				[8]  = {0.76,  0.025,  0.090,  0.100,   0.036,   0.23,    11.5,   1.26},
				[9]  = {0.80,  0.028,  0.087,  0.118,   0.046,   0.22,    11.0,   1.22},
				[10] = {0.82,  0.031,  0.084,  0.135,   0.056,   0.22,    10.8,   1.19},
				[11] = {0.85,  0.036,  0.081,  0.155,   0.068,   0.20,    10.5,   1.16},
				
				-- MMO approach
				[12] = {0.87,  0.042,  0.078,  0.180,   0.082,   0.18,    10.0,   1.12},
				[13] = {0.89,  0.052,  0.075,  0.210,   0.098,   0.17,    9.5,    1.08},
				
				-- Overspeed
				[14] = {0.91,  0.075,  0.072,  0.290,   0.135,   0.15,    9.0,    0.98},
				[15] = {0.94,  0.115,  0.068,  0.400,   0.195,   0.12,    8.5,    0.88},
				[16] = {0.98,  0.180,  0.060,  0.650,   0.290,   0.10,    7.5,    0.60},
			]]
            },
        },

        engine = {
            typeng 			= 4,
			type 			= "TurboFan",

			-- For Trent 972 engine
            Nmg             = 68.0,     -- N3 Idle RPM %
            Nominal_RPM     = 12200.0,  -- 100% speed high pressure turbine (N3)
            Nominal_Fan_RPM = 2900.0,   -- 100% fan speed (N1)

            MinRUD          = 0,
            MaxRUD          = 1,
            MaksRUD         = 1,
            ForsRUD         = 1,

            hMaxEng 		= 14.5,     -- Max effective engine alt [km]
            dcx_eng 		= 0.0135,   -- Nacelle drag

            -- FUEL FLOW SFC
            cemax   		= 0.605,	-- [kg/kgf/h] scaled
            cefor   		= 0.605,	-- [kg/kgf/h] scaled

			-- Altitude compensation
			-- Standard for high-bypass turbofans to 
			-- approximate proper altitude thrust lapse.
            dpdh_m  		= 88200/4,  -- [N/km per engine]
            dpdh_f  		= 88200/4,

            -- Thrust table (Static Total)
            table_data =
            {
				-- THRUST TABLE (4x Trent 972)
                -- CORRECTED: Flatter curve to prevent thrust starvation at altitude.
                -- At M0.85/11km, this provides ~300kN Net Thrust (matches Cruise Drag).

                -- 		 M     Pmax (N)   Pmax_ab (N)
                [1]  = {0.0,   1427000,   1427000}, -- Static
                [2]  = {0.1,   1420000,   1420000},
                [3]  = {0.2,   1410000,   1410000},
                [4]  = {0.3,   1395000,   1395000},
                [5]  = {0.4,   1380000,   1380000},
                [6]  = {0.5,   1360000,   1360000},
                [7]  = {0.6,   1340000,   1340000},
                [8]  = {0.7,   1310000,   1310000},
                [9]  = {0.8,   1280000,   1280000}, -- Cruise Base
                [10] = {0.85,  1260000,   1260000}, -- Mmo
                [11] = {0.9,   1150000,   1150000}, -- Drag rise
                [12] = {1.0,    800000,    800000},
            },
        },
    },

    -- ===================================================================
    -- DAMAGE MODEL
    -- ===================================================================

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
        [23] = {critical_damage = 5,  args = {223}}, -- wing out left 
        [24] = {critical_damage = 5,  args = {213}}, -- wing out right 
        [25] = {critical_damage = 2,  args = {226}}, -- eleron left 
        [26] = {critical_damage = 2,  args = {216}}, -- eleron right 
        [29] = {critical_damage = 5,  args = {224}, deps_cells = {23, 25}},
        [30] = {critical_damage = 5,  args = {214}, deps_cells = {24, 26}},
        [35] = {critical_damage = 6,  args = {225}, deps_cells = {23, 29, 25, 37}}, -- wing in left 
        [36] = {critical_damage = 6,  args = {215}, deps_cells = {24, 30, 26, 38}}, -- wing in right 
        [37] = {critical_damage = 2,  args = {228}},
        [38] = {critical_damage = 2,  args = {218}},
        [39] = {critical_damage = 2,  args = {244}, deps_cells = {53}},
        [40] = {critical_damage = 2,  args = {241}, deps_cells = {54}},
        [43] = {critical_damage = 2,  args = {243}, deps_cells = {39, 53}},
        [44] = {critical_damage = 2,  args = {242}, deps_cells = {40, 54}},
        [51] = {critical_damage = 2,  args = {240}}, -- elevator in left
        [52] = {critical_damage = 2,  args = {237}}, -- elevator in right
        [53] = {critical_damage = 2,  args = {248}}, -- rudder left
        [54] = {critical_damage = 2,  args = {247}},
        [56] = {critical_damage = 2,  args = {158}},
        [57] = {critical_damage = 2,  args = {157}},
        [59] = {critical_damage = 3,  args = {148}},
        [61] = {critical_damage = 2,  args = {147}},
        [82] = {critical_damage = 2,  args = {152}},
    },

    DamageParts = {
        [1] = "A_380-OBLOMOK-WING-R",
        [2] = "A_380-OBLOMOK-WING-L",
    },

    -- ===================================================================
    -- LIGHTS CONFIGURATION
    -- ===================================================================

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
                            typename = "Spot", position = { -34.536873, 3.050205, 0 },
							direction = {azimuth = math.rad(180.0)},
                            proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(180.0), angle_min = math.rad(170.0),
                        },
						{
							typename = "Omni", position = { -34.536873, 3.050205, 0 },
							proto = lamp_prototypes.ANO_3_Bl, movable = true,
						},
						{
							typename = "Spot", position = { -13.369998, 1.587861, -39.692001 },
							direction = {azimuth = math.rad(-60.0), elevation = math.rad(0)},
							proto = lamp_prototypes.BANO_8M_red, angle_max = math.rad(120.0), angle_min = math.rad(0),
						},
						{
							typename = "Spot", position = { -13.370016, 1.587861, 39.692390 },
							direction = {azimuth = math.rad(60.0), elevation = math.rad(0)},
							proto = lamp_prototypes.BANO_8M_green, angle_max = math.rad(120.0), angle_min = math.rad(0),
						},

						{	-- port empennage logo illumination. Source: https://www.cnn.com/travel/article/last-a380-emirates/index.html
                            typename = "Spot",  position = { -31.0, 2.7, -8.0 },
							direction = {azimuth = math.rad(70.0), elevation = math.rad(-48.0)},
                            proto = lamp_prototypes.FR_100, intensity_max = 160.0, angle_max = math.rad(80.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, power_up_t = 0.2, cool_down_t = 0.2, movable = true,
                        },
						{	-- starboard empennage logo illumination. Source: https://www.cnn.com/travel/article/last-a380-emirates/index.html
                            typename = "Spot",  position = { -31.0, 2.7, 8.0 },
							direction = {azimuth = math.rad(-70.0), elevation = math.rad(-48.0)},
                            proto = lamp_prototypes.FR_100, intensity_max = 160.0, angle_max = math.rad(80.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, power_up_t = 0.2, cool_down_t = 0.2, movable = true,
                        },

						-- Wing illumination. Source: https://www.cnn.com/travel/article/last-a380-emirates/index.html
						{
							typename = "Spot",  position = { 23.0, 1.20, -3.70 },
							direction = {azimuth = math.rad(-145.0), elevation = math.rad(1.0)},
							proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(30.0), angle_min = math.rad(0.0),
							cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
						{
							typename = "Spot",  position = { 23.0, 1.20, 3.70 },
							direction = {azimuth = math.rad(145.0), elevation = math.rad(1.0)},
							proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(30.0), angle_min = math.rad(0.0),
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
							typename = "Spot", position = { 31.954037, -3.893481, 0 }, argument = 51,
							direction = {azimuth = math.rad(0.0), elevation = math.rad(4.0)},
							proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(25.0), angle_min = math.rad(0),
							cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
						{
                            typename = "Spot",  position = { 15.0, -1.800, -5.50 },
							direction = {azimuth = math.rad(-8.0), elevation = math.rad(3.0)},
                            proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						{
                            typename = "Spot",  position = { 15.0, -1.800, 5.50 },
							direction = {azimuth = math.rad(8.0), elevation = math.rad(3.0)},
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
							typename = "Spot", position = { 31.954037, -3.893481, 0 }, argument = 51,
							direction = {azimuth = math.rad(0.0), elevation = math.rad(4.0)},
							proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(33.0), angle_min = math.rad(0),
							cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
						{
                            typename = "Spot",  position = { 15.0, -1.800, -5.50 },
							direction = {azimuth = math.rad(-10.0), elevation = math.rad(3.0)},
                            proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(30.0), angle_min = math.rad(0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						{
                            typename = "Spot",  position = { 15.0, -1.800, 5.50 },
							direction = {azimuth = math.rad(10.0), elevation = math.rad(3.0)},
                            proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(30.0), angle_min = math.rad(0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },

						-- Runway turnoff lights. These really ought to be animated as part of the wheel steering mechanism, but I don't know how to do that.
						{
                            typename = "Spot",  position = { 28.2, -0.40, -3.70 },
							direction = {azimuth = math.rad(-60.0), elevation = math.rad(5.0)},
                            proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(45.0), angle_min = math.rad(0.0),
                            cool_down_t = 0.3, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						{
                            typename = "Spot",  position = { 28.2, -0.40, 3.70 },
							direction = {azimuth = math.rad(60.0), elevation = math.rad(5.0)},
                            proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(45.0), angle_min = math.rad(0.0),
                            cool_down_t = 0.3, exposure = {{0, 0.9, 1.0}}, movable = true,
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
                            typename = "natostrobelight", position = { 15.00, 9.800, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 2.5, -4.60, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.5,
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
                            typename = "natostrobelight", position = { 15.00, 9.800, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 2.5, -4.60, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.5,
                        },

						{
                            typename = "Spot", position = { -13.369998, 1.587861, -39.692001 },
                            controller = "VariablePatternStrobe", mode = "2 Flash Long",
							proto = lamp_prototypes.MPS_1, intensity_max = 750.0, period = 0.250, phase_shift = 0.25,
							direction = {azimuth = math.rad(-90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
                        {
                            typename = "Spot", position = { -13.370016, 1.587861, 39.692390 },
                            controller = "VariablePatternStrobe", mode = "2 Flash Long",
							proto = lamp_prototypes.MPS_1, intensity_max = 750.0, period = 0.250, phase_shift = 0.25,
							direction = {azimuth = math.rad(90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
						{
                            typename = "Spot", position = { -34.536873, 3.050205, 0 },
                            controller = "VariablePatternStrobe", mode = "2 Flash Long",
							proto = lamp_prototypes.MPS_1, intensity_max = 750.0, period = 0.250, phase_shift = 0.25,
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
                            typename = "natostrobelight", position = { 15.00, 9.800, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 2.5, -4.60, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.5,
                        },
					},
				},
			},
		},
	},
	},
}

add_aircraft(A_380)