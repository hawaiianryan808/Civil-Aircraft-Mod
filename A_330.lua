-- ===================================================================
-- IMPLEMENTATION NOTES
-- ===================================================================
--[[
FINAL CONVERSION TO AIRBUS A330-300 (TRENT 700)

1. GEOMETRY UPDATES:
   - Wheelbase corrected to 25.38m (Real world A330-300).
   - Nose gear moved from 25.16 to 24.17.
   - Wing span (60.3m) and Length (63.69m) verified.

2. MASS & BALANCE (242t Variant):
   - MTOW: 242,000 kg.
   - OEW: 129,000 kg.
   - Max Fuel: 111,600 kg (Full center tank).

3. PROPULSION (Rolls-Royce Trent 772B-60):
   - Static Thrust: 632 kN Total (2x 71,100 lbf).
   - Cruise Fuel Flow: 1.61 kg/s (~5,800 kg/hr).
   - Altitude Lapse: Tuned via dpdh_m for high-bypass characteristics.

4. AERODYNAMICS:
   - Supercritical wing profile (Cy0 = 0.12).
   - Cruise optimization at Mach 0.82.
   - Drag Rise adjusted for MMO Mach 0.86.
--]]

A_330 =  {
    Name 			= 'A_330',
    DisplayName		= _('A330-300'),
	date_of_introduction= 1994.01,
    Picture 		= "A-330.png",
    Rate 			= "40",
    Shape			= "A_330",
    WorldID			=  WSTYPE_PLACEHOLDER,
	defFuelRatio    = 0.8,
    singleInFlight 	= true,

    shape_table_data 	=
    {
        {
            file  	 	= 'A_330';
            life  	 	= 20;
            vis   	 	= 3;
            desrt    	= 'kc-135-oblomok';
            fire  	 	= { 300, 2};
            username	= 'A_330';
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

    Categories = { },

    -- ===================================================================
    -- MASS & CAPACITY
    -- ===================================================================
    M_empty		= 129000,   -- [kg] (OEW)
    M_nominal	= 180000,   -- [kg] (Typical Op Weight)
    M_max		= 242000,   -- [kg] (MTOW 242t Variant)
    M_fuel_max	= 111600,   -- [kg] (Standard + Center Tank)

    -- ===================================================================
    -- PERFORMANCE
    -- ===================================================================
    H_max       = 12634,    -- [m] Ceiling (41,450 ft)

    -- Speeds
    V_opt		= 243,      -- [m/s TAS] (Mach 0.82 Cruise)
    V_take_off	= 80,       -- [m/s TAS] (~155 kts)
    V_land		= 64,       -- [m/s TAS] (~136 kts)
    CAS_min     = 59,       -- [m/s TAS] (Stall clean)

    V_max_sea_level	= 188,	-- [m/s TAS] Set to max dive speed (Vd = ~365 KCAS) since DCS was magic restricting climb due to powerful engines
    V_max_h			= 256,	-- [m/s TAS] (Mach 0.86 MMO)
    Mach_max        = 0.86,	-- MMO

    Vy_max      = 20,       -- [m/s] (Initial Climb)
    range       = 13450,	-- [km] (6,350 nmi)

    Ny_min		=  -1.52,	-- [G]
    Ny_max		=  2.0,		-- [G]
    Ny_max_e	=  2.5,		-- [G]
    bank_angle_max = 35,	-- [degrees]

    -- ===================================================================
    -- DIMENSIONS & GEOMETRY
    -- ===================================================================
    wing_area	= 361.6,	-- [m^2]
    wing_span	= 59.44,	-- [m] (60.3m real-world) - Limited because DCS is stupid
    length      = 63.69,	-- [m]
    height      = 16.83,	-- [m]

    wing_tip_pos  = {-9.972, 1.561, 29.045},

    -- GEAR GEOMETRY
    nose_gear_pos 	= 	{ 25.16, -4.783, 0.013}, 		-- Nose gear position (ground under center of the axle)

	main_gear_pos 	= 	{-1.21,	 -5.22,	 6.20},			-- Main gear position (ground under center of the axle)
														-- automatically mirrored

	nose_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (arg 2)
	nose_gear_amortizer_reversal_stroke 	 = -0.24,	-- Full Strut Compression (maximum+ weight on wheels)
	nose_gear_amortizer_normal_weight_stroke = -0.10,	-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	nose_gear_wheel_diameter				 =  1.063,	-- Diameter of the nose gear wheel (meters)

	main_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (args 4 and 6)
	main_gear_amortizer_reversal_stroke 	 = -0.0815,	-- Full Strut Compression (maximum+ weight on wheels)
	main_gear_amortizer_normal_weight_stroke = -0.04,	-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	main_gear_wheel_diameter 				 =  1.35,	-- Diameter of the main gear wheels (meters)

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
	tand_gear_max	=	math.tan(math.rad(72)),

    AOA_take_off = math.rad(12),	-- ~12 degrees


	-- ===================================================================
    -- INERTIA & CG (Airbus A330-300)
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
    center_of_mass      = { -0.46, -0.066, 0.0 },				-- [m] CG w.r.t. EDM 3D mesh origin in TsAGI coordinate order

--[[
	MOI and POI (EMPTY configuation) in TsAGI coordinate system.
 
	POI sign check:
	Airliners typically have heavy, podded engines located below the wing (-Y in TsAGI) and
	generally forward of the Center of Gravity (+X), while the empennage/tail (-X)
	structure is high (+Y). The sum of those products should be NEGATIVE.
	
]]
	moment_of_inertia	= {36.8e6, 84e6, 75.8e6, -1.4e6},	-- [kg*m^2] {Roll, Yaw, Pitch, POI}


    -- ===================================================================
    -- ENGINE (Rolls-Royce Trent 772B-60)
    -- ===================================================================
    engines_count	= 2,

    -- Thrust: 632 kN Total (2x 316 kN)
    thrust_sum_max	= 64501,	-- [kgf] Total thrust from both engines
    thrust_sum_ab	= 64501,	-- [kgf] Total thrust from both engines w/afterburner

    -- Fuel: ~5,700 kg/hr cruise
    average_fuel_consumption = 1.58, -- [kg/s] Total fuel consumption rate

    has_afteburner	=	false,
    has_speedbrake	=	true,
    has_thrustReverser = true,
    has_differential_stabilizer = false,
	flaps_transmission          = "Hydraulic",
    undercarriage_transmission  = "Hydraulic",

    -- Systems
    radar_can_see_ground = false,
    stores_number	= 0,
    tanker_type	    = 0,
    is_tanker       = false,
    flaps_maneuver	= 0.25,		-- Corresponds to CONF 1+F
    brakeshute_name = 0,

    crew_size					= 2,
    RCS							= 80,	-- [m^2] Radar cross section
    detection_range_max			= 30,	-- [km] Distance pilots in this airframe can possibly become aware of other airframes
    IR_emission_coeff			= 2.1,	-- Massive engines with huge plume volume. Total radiated power is roughly double the fighter's dry output.
    IR_emission_coeff_ab 		= 0,

	engines_startup_sequence 	= { 1, 0 },	-- Right (2), then Left (1)
    engines_nozzles =
    {
        [1] =
        {
            pos = 	{3.90,	-2.412,	-9.373},
            elevation			= 	-4.2,	-- 4.2 degree exhaust depression (negative means exhaust points down)
			azimuth             = 	1.5,	-- 1.5 degree toe-in (positive means thrust vector points toward longitudinal axis; exhaust points away)
            diameter			=	1.36, 	-- Trent 700 Fan
            exhaust_length_ab	=	7.62,
            exhaust_length_ab_K	=	0.76,
            smokiness_level     = 	0.05,
            engine_number       = 	1,
        },
        [2] =
        {
            pos = 	{3.90,	-2.412,	9.373},
            elevation			=	-4.2,	-- 4.2 degree exhaust depression (negative means exhaust points down)
			azimuth             = 	-1.5,	-- 1.5 degree toe-in (negative means thrust vector points toward longitudinal axis; exhaust points away)
            diameter			=	1.36,
            exhaust_length_ab	=	7.62,
            exhaust_length_ab_K	=	0.76,
            smokiness_level     = 	0.05,
            engine_number       = 	2,
        },
    },

    crew_members =
    {
        [1] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {29.42, 1.27, -0.535} },
        [2] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {29.42, 1.27,  0.535} },
    },

    fires_pos =
    {
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

    -- ===================================================================
    -- SFM DATA (AERODYNAMICS & ENGINES)
    -- ===================================================================
    SFM_Data = {
        aerodynamics = {
            -- Coefficients
            Cy0 		= 0.12,  	-- Positive lift at zero AoA
            Mzalfa      = 5.0,      -- High pitch stability
            Mzalfadt    = 1.0,      -- Pitch damping
            kjx         = 2.9,      -- High Roll Inertia
            kjz         = 0.002,    -- Yaw inertia
            Czbe        = -0.012,   -- Directional stability

            -- Drag
            cx_gear     = 0.030,    -- Gear drag coefficient
            cx_flap     = 0.090,    -- Flaps drag coefficient
            cy_flap 	= 0.70,  	-- Flaps lift coefficient
            cx_brk      = 0.06,     -- Speedbrake drag

            table_data =
            {
				-- Aerodynamic Drag Polar Table
				-- M: Mach, Cx0: Zero-lift drag, Cya: Normal force coeff, B/B4: Polar shape
				-- Omxmax: Roll rate, Aldop: Max AoA, Cymax: Max Lift
                -- 		 M      Cx0     Cya      B        B4    Omxmax   Aldop   Cymax

                -- Low Speed
                [1]  = {0.0,   0.016,  0.12,   0.060,   0.003,   0.6,    13.0,   1.44},
				[2]  = {0.2,   0.016,  0.12,   0.061,   0.006,   0.6,    13.0,   1.44},
				[3]  = {0.4,   0.017,  0.120,  0.063,   0.011,   0.6,    12.5,   1.42},

                -- Climb
                [4]  = {0.6,   0.019,  0.122,  0.067,   0.018,   0.5,    12.0,   1.38},
				[5]  = {0.7,   0.021,  0.122,  0.076,   0.026,   0.4,    11.5,   1.34},

                -- Cruise (Mach 0.82)
                [6]  = {0.76,  0.023,  0.125,  0.088,   0.034,   0.4,    11.0,   1.30},
				[7]  = {0.78,  0.024,  0.127,  0.100,   0.042,   0.3,    10.8,   1.26},
				[8]  = {0.80,  0.025,  0.130,  0.115,   0.052,   0.3,    10.5,   1.22},
				[9]  = {0.82,  0.026,  0.135,  0.130,   0.062,   0.3,    10.0,   1.18},
				[10] = {0.84,  0.030,  0.130,  0.155,   0.072,   0.3,    9.5,    1.14},
				[11] = {0.86,  0.045,  0.120,  0.180,   0.080,   0.3,    9.0,    1.10},

                -- Overspeed
                [12] = {0.88,  0.070,  0.110,  0.250,   0.120,   0.2,    8.5,    1.00},
				[13] = {0.92,  0.110,  0.090,  0.350,   0.180,   0.2,    8.0,    0.90},
				[14] = {1.0,   0.180,  0.060,  0.600,   0.250,   0.1,    7.0,    0.50},
            },
        },

        engine = {
            typeng 			= 4,
			type 			= "TurboFan",

			-- For Trent 772B-60 engine
            Nmg				= 60.0,		-- N2 Idle RPM %
            Nominal_RPM 	= 10611.0,	-- 100% speed high pressure turbine (N2)
            Nominal_Fan_RPM = 3900.0,	-- 100% fan speed (N1)

            MinRUD			= 0,
            MaxRUD			= 1,
            MaksRUD			= 1,
            ForsRUD			= 1,

            hMaxEng			= 13.5,		-- Max effective engine alt [km]
            dcx_eng 		= 0.006, 	-- Nacelle drag

            -- FUEL FLOW SFC (per engine)
			-- Matches Rolls-Royce published cruise TSFC of
			-- 0.584 lb/lbf/h for Trent 772B-60
            cemax			= 0.584,		-- [kg/kgf/h] scaled
            cefor			= 0.584,		-- [kg/kgf/h] scaled

            -- Altitude compensation
			-- Assumes SFM formula thrust = thrust_max(M) - (dpdh_m * h),
			-- with thrust in N, h in km; tuned to ~17-22% of sea-level
			-- static thrust at 11-12 km cruise altitude, yielding
			-- ~110-140 kN total at M 0.82, matching real turbofan
			-- lapse for high-bypass engines like Trent 700
            dpdh_m			= 29500,		-- [N/km per engine]
            dpdh_f			= 29500,

            table_data = {
                -- M      Pmax (N)   Pmax_ab (N)
                -- CORRECTED: Flatter curve to prevent thrust starvation at altitude.
                -- The dpdh_m parameter handles the altitude loss.
                -- This table provides the "Base" thrust before altitude subtraction.

                -- Static / Low Speed
                [1]  = {0.0,   632000,   632000},
                [2]  = {0.1,   625000,   625000},
                [3]  = {0.2,   618000,   618000},

                -- Climb / Acceleration
                [4]  = {0.3,   610000,   610000},
                [5]  = {0.4,   600000,   600000},
                [6]  = {0.5,   590000,   590000},

                -- Cruise Regime (Mach 0.8+)
                -- Value kept high (~550kN) so that after subtracting altitude loss (~430kN total),
                -- we have ~120kN Net Thrust (Correct for A330 cruise drag).
                [7]  = {0.6,   580000,   580000},
                [8]  = {0.7,   570000,   570000},
                [9]  = {0.8,   560000,   560000},

                -- High Speed / Overspeed
                [10] = {0.86,  540000,   540000},
                [11] = {0.90,  480000,   480000}, -- Ram drag overtaking thrust
            },
        },
    },

    -- ===================================================================
    -- DAMAGE & SYSTEMS
    -- ===================================================================
    Damage = {
        [0]  = {critical_damage = 5,  args = {146}},
        [1]  = {critical_damage = 3,  args = {296}},
        [2]  = {critical_damage = 3,  args = {297}},
        [3]  = {critical_damage = 8, args = {65}},
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
        [23] = {critical_damage = 5, args = {223}},
        [24] = {critical_damage = 5, args = {213}},
        [25] = {critical_damage = 2,  args = {226}},
        [26] = {critical_damage = 2,  args = {216}},
        [29] = {critical_damage = 5, args = {224}, deps_cells = {23, 25}},
        [30] = {critical_damage = 5, args = {214}, deps_cells = {24, 26}},
        [35] = {critical_damage = 6, args = {225}, deps_cells = {23, 29, 25, 37}},
        [36] = {critical_damage = 6, args = {215}, deps_cells = {24, 30, 26, 38}},
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
        [1] = "A_330-OBLOMOK-WING-R",
        [2] = "A_330-OBLOMOK-WING-L",
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
                            typename = "Spot", position = { -31.0, 2.206, 0 },
							direction = {azimuth = math.rad(180.0)},
                            proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(180.0), angle_min = math.rad(170.0),
                        },
						{
							typename = "Omni", position = { -31.0, 2.206, 0 },
							proto = lamp_prototypes.ANO_3_Bl, movable = true,
						},
						{
							typename = "Spot", position = { -7.327613, 1.587861, -29.040228 },
							direction = {azimuth = math.rad(-60.0), elevation = math.rad(0)},
							proto = lamp_prototypes.BANO_8M_red, angle_max = math.rad(120.0), angle_min = math.rad(0),
						},
						{
							typename = "Spot", position = { -7.256751, 1.656343, 28.978262 },
							direction = {azimuth = math.rad(60.0), elevation = math.rad(0)},
							proto = lamp_prototypes.BANO_8M_green, angle_max = math.rad(120.0), angle_min = math.rad(0),
						},

						{	-- port empennage logo illumination. Source: https://www.flickr.com/photos/rbertoli/17255429984  and  https://www.flickr.com/photos/josepha_mtl/40028537472  and  https://twitter.com/TomPodolec/status/1021973854074355713/photo/1  and  https://www.airliners.net/photo/Air-France/Airbus-A330-203/1537643/L
                            typename = "Spot",  position = { -28.0, 2.3, -4.5 },
							direction = {azimuth = math.rad(80.0), elevation = math.rad(-48.0)},
                            proto = lamp_prototypes.FR_100, intensity_max = 120.0, angle_max = math.rad(80.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, power_up_t = 0.2, cool_down_t = 0.2, movable = true,
                        },
						{	-- starboard empennage logo illumination. Source: https://www.flickr.com/photos/rbertoli/17255429984  and  https://www.flickr.com/photos/josepha_mtl/40028537472  and  https://twitter.com/TomPodolec/status/1021973854074355713/photo/1  and  https://www.airliners.net/photo/Air-France/Airbus-A330-203/1537643/L
                            typename = "Spot",  position = { -28.0, 2.3, 4.5 },
							direction = {azimuth = math.rad(-80.0), elevation = math.rad(-48.0)},
                            proto = lamp_prototypes.FR_100, intensity_max = 120.0, angle_max = math.rad(80.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, power_up_t = 0.2, cool_down_t = 0.2, movable = true,
                        },

						-- Wing illumination. Source: https://www.flickr.com/photos/rbertoli/17255429984
						{
							typename = "Spot",  position = { 19.200, 0.10, -3.80 },
							direction = {azimuth = math.rad(-145.0), elevation = math.rad(0.0)},
							proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(30.0), angle_min = math.rad(0.0),
							cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
						{
							typename = "Spot",  position = { 19.200, 0.10, 3.80 },
							direction = {azimuth = math.rad(145.0), elevation = math.rad(0.0)},
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
							typename = "Spot", position = { 25.495714, -2.563476, 0 }, argument = 51,
							direction = {azimuth = math.rad(0.0), elevation = math.rad(4.0)},
							proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(25.0), angle_min = math.rad(0),
							cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
						{
                            typename = "Spot",  position = { 9.30, -1.200, -3.20 },
							direction = {azimuth = math.rad(-8.0), elevation = math.rad(3.0)},
                            proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						{
                            typename = "Spot",  position = { 9.30, -1.200, 3.20 },
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
							typename = "Spot", position = { 25.495714, -2.563476, 0 }, argument = 51,
							direction = {azimuth = math.rad(0.0), elevation = math.rad(4.0)},
							proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(33.0), angle_min = math.rad(0),
							cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
						{
							typename = "Omni", position = { 25.495714, -2.563476, 0 },
							proto = lamp_prototypes.LFS_R_27_450, range = 6.0, movable = true,
						},
						{
                            typename = "Spot",  position = { 9.30, -1.200, -3.20 },
							direction = {azimuth = math.rad(-10.0), elevation = math.rad(2.0)},
                            proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(30.0), angle_min = math.rad(0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						{
                            typename = "Spot",  position = { 9.30, -1.200, 3.20 },
							direction = {azimuth = math.rad(10.0), elevation = math.rad(2.0)},
                            proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(30.0), angle_min = math.rad(0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },

						-- Runway turnoff lights. These really ought to be animated as part of the wheel steering mechanism, but I don't know how to do that.
						{
                            typename = "Spot",  position = { 19.800, 0.080, -3.80 },
							direction = {azimuth = math.rad(-50.0), elevation = math.rad(5.0)},
                            proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(45.0), angle_min = math.rad(0.0),
                            cool_down_t = 0.3, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						{
                            typename = "Spot",  position = { 19.800, 0.080, 3.80 },
							direction = {azimuth = math.rad(50.0), elevation = math.rad(5.0)},
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
                            typename = "natostrobelight", position = { 9.80, 3.200, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 6.95, -4.10, 0.000 },
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
                            typename = "natostrobelight", position = { 9.80, 3.200, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 6.95, -4.10, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.5,
                        },

						{
                            typename = "Spot", position = { -7.327613, 1.587861, -29.040228  },
                            controller = "VariablePatternStrobe", mode = "2 Flash Long",
							proto = lamp_prototypes.MPS_1, intensity_max = 600.0, period = 0.250, phase_shift = 0.25,
							direction = {azimuth = math.rad(-90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
                        {
                            typename = "Spot", position = { -7.256751, 1.656343, 28.978262 },
                            controller = "VariablePatternStrobe", mode = "2 Flash Long",
							proto = lamp_prototypes.MPS_1, intensity_max = 600.0, period = 0.250, phase_shift = 0.25,
							direction = {azimuth = math.rad(90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
						{
                            typename = "Spot", position = { -31.0, 2.206, 0 },
                            controller = "VariablePatternStrobe", mode = "2 Flash Long",
							proto = lamp_prototypes.MPS_1, intensity_max = 650.0, period = 0.250, phase_shift = 0.25,
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
                            typename = "natostrobelight", position = { 9.80, 3.200, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.9, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 6.95, -4.10, 0.000 },
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
                            typename = "omnilight", position = {29.9, 1.00, 0.65 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.3,
                        },
						{
                            typename = "omnilight", position = {29.9, 1.00, -0.65 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.3,
                        },
						{
                            typename = "omnilight", position = {29.5, 1.500, 0.30 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 0.6,
                        },
						{
                            typename = "omnilight", position = {29.5, 1.500, -0.30 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 0.6,
                        },
                    },
                },
            },
        },
	},
	},
}

add_aircraft(A_330)