-- ===================================================================
-- IMPLEMENTATION NOTES (CONVERSION TO B757-300 NO WINGLETS)
-- ===================================================================
--[[
CONFIGURATION: BOEING 757-300 (Standard / No Winglets)
				with 2x Rolls-Royce RB211-535E4B engines

1. GEOMETRY UPDATES:
   - Length: 54.43 m (Stretched by 7.1m vs -200).
   - Wheelbase: 22.35 m (73 ft 4 in).
   - Wingspan: 38.05 m (Standard, no winglets).
   - Tailstrike geometry: Critical angle reduced due to length.

2. MASS & BALANCE:
   - MTOW: 123,600 kg (272,500 lbs).
   - OEW: 64,590 kg (Heavier airframe).
   - Max Fuel: 34,400 kg (Same tank capacity as -200).

3. AERODYNAMICS:
   - Parasitic Drag (Cx0): Increased to 0.018 (More fuselage surface area).
   - Pitch Inertia (kjz): Increased significantly (Longer moment arm).
   - Pitch Damping (Mzalfadt): Increased.
   - Rotation: Slower rotation rate required to avoid tailstrike.

4. ENGINE (RB211-535E4B):
   - Thrust: 43,100 lbf (191.7 kN) per engine.
   - Same rating as high-spec -200, but lower Thrust-to-Weight ratio.
   - Climb Rate: Reduced from 22 m/s to 15.2 m/s due to weight.
--]]

local nose_x	=	26.51
local nose_y	=	-1.37

B_757 =  {
    Name                = 'B_757',
    DisplayName         = _('B757-300'),
	date_of_introduction= 1999.03,
    Picture             = "B-757.png",
    Rate                = "40",
    Shape               = "B_757",
    WorldID             =  WSTYPE_PLACEHOLDER, 
	defFuelRatio    	= 0.8, 
    singleInFlight      = true,

    shape_table_data 	= 
    {
        {
            file  	 	= 'B_757';
            life  	 	= 20; 
            vis   	 	= 3; 
            desrt    	= 'kc-135-oblomok'; 
            fire  	 	= { 300, 2}; 
            username	= 'B_757';
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

    mapclasskey         = "P0091000029",
    attribute           = {wsType_Air, wsType_Airplane, wsType_Cruiser, WSTYPE_PLACEHOLDER, "Transports",},
    Categories          = { },

    -- ===================================================================
    -- MASS & DIMENSIONS (757-300)
    -- ===================================================================
    
    -- Mass Parameters
    M_empty     = 64590,    -- [kg] (OEW approx 142,400 lbs)
    M_nominal   = 108000,   -- [kg] (Heavier typical operating weight)
    M_max       = 123600,   -- [kg] (MTOW: 272,500 lbs)
    M_fuel_max  = 34792,    -- [kg] (Standard capacity)

    -- Dimensions
    length      = 54.43,    -- [m] (178 ft 7 in) - Stretched
    height      = 13.56,    -- [m] (44 ft 6 in)
    wing_area   = 181.25,   -- [m^2] (Same wing)
    wing_span   = 38.05,    -- [m] (Standard, No Winglets)
	
	-- Inertia & CG
	
	-- Boeing 757-300 LOADED Center of Mass
	-- Estimated for a model with origin at the nose tip (nominally loaded)
	-- center_of_mass = {-24.5 + nose_x, -1.0 + nose_y, 0.0},
	
	-- Boeing 757-300 EMPTY Center of Mass
	-- Located approx 17% MAC (approx 23.5 meters aft of nose)
	-- center_of_mass = {-23.5 + nose_x, -0.5 + nose_y, 0.0},
	
	-- B757-300 Inertia: {Roll, Yaw, Pitch}
    -- Calculated by scaling B747 reference data.
    -- Note: 757-300 is a "flying pencil," so Yaw/Pitch inertia is high relative to Roll.
	-- moment_of_inertia	= {3200000, 13300000, 8800000},	-- [kg*m^2] {Roll, Yaw, Pitch}

    -- ===================================================================
    -- PERFORMANCE PARAMETERS
    -- ===================================================================
    
    -- Speeds
    V_opt           = 243,      -- [m/s TAS] (Mach 0.80 cruise)
    V_take_off      = 75,       -- [m/s TAS] (Typical V2 ~145-150 kts / ~75-77 m/s at MTOW)
    V_land          = 72,       -- [m/s TAS] (Higher Vref)
    V_max_sea_level = 180,      -- [m/s TAS] (350 KCAS Vmo)
    V_max_h         = 248,      -- [m/s TAS] (Mach 0.86 MMO)
    CAS_min         = 68,       -- [m/s TAS] (Higher stall speed)
    Mach_max        = 0.86,     

    -- Climb & Ceiling
    H_max           = 12800,    -- [m] 
    Vy_max          = 15.2,     -- [m/s] (~3,000 ft/min)

    -- Range & Fuel
    range           = 6290,     -- [km] (3,400 nm - Reduced range vs -200)
    average_fuel_consumption = 1.94, -- [kg/sec] (Slightly higher burn for heavier aircraft)

    -- Limits
    Ny_min      	= 0.5,      -- [G]
    Ny_max      	= 2.0,      -- [G]
    Ny_max_e    	= 2.5,      -- [G]
    bank_angle_max  = 30,       -- [degrees]

    -- Takeoff Geometry
    AOA_take_off    = math.rad(7.0),    -- Reduced rotation angle to prevent tailstrike

    -- ===================================================================
    -- PROPULSION (RB211-535E4B)
    -- ===================================================================
    
    -- Thrust: 43,100 lbf per engine (Same max rating, but required for -300)
    thrust_sum_max      = 39090,   -- [kgf]
    thrust_sum_ab       = 39090,   -- [kgf]
    has_afteburner      = false,
    has_thrustReverser  = true,

    -- ===================================================================
    -- SYSTEM & EQUIPMENT
    -- ===================================================================
    
    has_speedbrake              = true,
    has_differential_stabilizer = false, 
    radar_can_see_ground        = false,
	flaps_transmission          = "Hydraulic",
    undercarriage_transmission  = "Hydraulic",
    RCS                         = 60,   -- [m^2] Larger fuselage
	detection_range_max			= 30,	-- [km] Distance pilots in this airframe can possibly become aware of other airframes
    IR_emission_coeff           = 0.6,
    IR_emission_coeff_ab        = 0,
    is_tanker                   = false,
    tanker_type                 = 0,
    crew_size                   = 2,

    -- Gear Geometry
	nose_gear_pos 	= 	{21.394, -4.751, 0}, 			-- Nose gear position (ground under center of the axle)
		
	main_gear_pos 	= 	{-0.87, -4.784, 4.27},			-- Main gear position (ground under center of the axle)
														-- automatically mirrored
	
	nose_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (arg 2)
	nose_gear_amortizer_reversal_stroke 	 = -0.4188,	-- Full Strut Compression (maximum+ weight on wheels)
	nose_gear_amortizer_normal_weight_stroke = -0.0859,	-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	nose_gear_wheel_diameter				 =  0.928,	-- Diameter of the nose gear wheel (meters)

	main_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (args 4 and 6)
	main_gear_amortizer_reversal_stroke 	 = -0.1456,	-- Full Strut Compression (maximum+ weight on wheels)
	main_gear_amortizer_normal_weight_stroke = -0.04220,-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	main_gear_wheel_diameter 				 =  1.082,	-- Diameter of the main gear wheels (meters)
	
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
	tand_gear_max	=	math.tan(math.rad(65)),

    -- Control Surfaces
    flaps_maneuver              = 5/30,		-- Corresponds to takeoff Flaps 5; Flaps 30 for landing (30 is max)
    -- Standard Tips (No Winglets)
    wing_tip_pos                = {-3.71, 0.00, 18.82},
    stores_number               = 0,
    brakeshute_name             = 0,
	
	engines_count				= 2,
	engines_startup_sequence 	= { 1, 0 },
    engines_nozzles = 
    {
        [1] = {
            pos                 = {1.87, -2.705, -6.698},
            elevation			= -2.5,	-- 2.5 degree exhaust depression (negative means thrust causes nose to pitch down)
			azimuth             = 2.0,	-- 2.0 degree toe-in (positive means thrust vector points toward longitudinal axis; exhaust points away)
            diameter            = 1.21,
            exhaust_length_ab   = 8.22,
            exhaust_length_ab_K = 0.76,
            smokiness_level     = 0.01, -- Clean burning modern turbofan
			engine_number       = 1,
        }, 
        [2] = {
            pos                 = {1.87, -2.705, 6.698},
            elevation			= -2.5,	-- 2.5 degree exhaust depression (negative means thrust causes nose to pitch down)
			azimuth             = -2.0,	-- 2.0 degree toe-in (negative means thrust vector points toward longitudinal axis; exhaust points away)
            diameter            = 1.21,
            exhaust_length_ab   = 8.22,
            exhaust_length_ab_K = 0.76,
            smokiness_level     = 0.01,
			engine_number       = 2,
        }, 
    }, 

    crew_members = 
    {
        [1] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {19.0, 1.5, -0.5} }, -- Pilot
        [2] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {19.0, 1.5,  0.5} }, -- Co-Pilot
    },

    fires_pos = 
    {
        [1] = 	{-0.138,	-0.79,	 0},
        [2] = 	{-0.138,	-0.79,	 5.741},
        [3] = 	{-0.138,	-0.79,	-5.741},
        [4] = 	{-0.82,      0.265,	 2.774},
        [5] = 	{-0.82,      0.265,	-2.774},
        [6] = 	{-0.82,      0.255,	 4.274},
        [7] = 	{-0.82,      0.255,	-4.274},
        [8] = 	{-0.347,	-1.875,	 8.138},
        [9] = 	{-0.347,	-1.875,	-8.138},
        [10] = 	{-5.024,	-1.353,	 13.986},
        [11] = 	{-5.024,	-1.353,	-13.986},
    },

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
    Tasks = { aircraft_task(Transport) },	
    DefaultTask = aircraft_task(Nothing),

    -- ===================================================================
    -- FLIGHT MODEL DATA (SFM)
    -- ===================================================================
    SFM_Data = {
        aerodynamics = 
        {
            -- Control authority parameters
            Cy0         = 0.12,     -- 0 degree AoA lift
            Mzalfa      = 4.8,      -- Increased pitch stability (longer body)
            Mzalfadt    = 1.1,      -- Increased pitch damping
            kjx         = 2.45,     -- High roll inertia
            kjz         = 0.0018,   -- High pitch inertia (The "Flying Pencil")
            Czbe        = -0.018,   -- Directional stability
            
            -- Drag coefficients
            cx_gear     = 0.035,    -- Gear drag coefficient
            cx_flap     = 0.065,    -- Flaps drag coefficient
            cy_flap     = 1.05,		-- Flaps lift coefficient
            cx_brk      = 0.09,     -- Speedbrake drag
            
            table_data = 
            {	
				-- Aerodynamic Drag Polar Table
				-- M: Mach, Cx0: Zero-lift drag, Cya: Normal force coeff, B/B4: Polar shape
				-- Omxmax: Roll rate, Aldop: Max AoA, Cymax: Max Lift
				-- 		M       Cx0     Cya      B        B4    Omxmax   Aldop   Cymax
				-- REVISION: Slightly higher form drag Cx0 for stretch
				
				-- Low Speed
				[1]  = {0.0,   0.018,  0.09,   0.035,   0.001,   0.35,   13,     1.45},
				[2]  = {0.2,   0.018,  0.09,   0.035,   0.001,   0.45,   13,     1.45},
				[3]  = {0.4,   0.019,  0.09,   0.035,   0.002,   0.45,   12.5,   1.45},
				
				-- Climb
				[4]  = {0.6,   0.021,  0.088,  0.04,    0.01,    0.50,   15,     1.4},
				
				-- Cruise (Mach 0.78 - 0.82 typical)
				[5]  = {0.7,   0.024,  0.087,  0.045,   0.02,    0.50,   14,	 1.30},
				[6]  = {0.8,   0.026,  0.086,  0.048,   0.03,    0.50,   14.0,	 1.05},
				[7]  = {0.84,  0.032,  0.085,  0.05,    0.03,    0.45,   13,	 1.20},
				
				-- Mach Limit
				[8]  = {0.88,  0.055,  0.100,  0.18,   0.100,  	 0.7,    11.0,	 0.80},
				[9]  = {0.9,   0.100,  0.082,  0.30,   0.200,    0.5,    12,     1.00},
				[10] = {1.0,   0.150,  0.080,  0.50,   0.300,    0.3,    8.0,    0.40},
            },
			
			
-- -- BOEING 757-300 REPRESENTATIVE AERODYNAMIC TABLES

-- -- https://aero.us.es/adesign/Slides/Extra/Stability/Dynamic_Stability/Airplane_Data.pdf

-- -- PITCHING MOMENT COEFFICIENT (Mz)
-- -- Rows: Mach Number
-- -- Cols: Angle of Attack (AoA) in degrees?
-- -- Values: Positive = Nose Up, Negative = Nose Down.
-- -- Trend: Should decrease as AoA increases (Stable).

-- -- Pitching Moment (Mz)
-- -- The 757-300 is stable, so as AoA increases, Mz becomes more negative.
-- -- At high Mach (0.8+), the curve shifts down (Mach tuck).
-- -- 16 Columns total
-- mz_table_data =
-- {
			
-- --[[
	-- mz_table_data columns:
	
	-- [1] = Mach,
	-- [2] = Stall AoA (rad) - Angle where lift/pitch linearity breaks (Stall onset),
	-- [3] = Stall sharpness factor - How abrupt the pitch break is after stall,
	-- [4] = Pitch damping (C_m_q) - Resistence to rotation,
	-- [5] = Max AoA (rad) - Hard aerodynamic limit for the simulation,
	-- [6] = Elevator Effectiveness (C_m_delta-e) - Control authority,
	-- [7] = Flap/Spoiler pitch moment - Pitch change due to drag devices,
	-- [8] = Pitch moment at 0 AoA (C_m0) - The "Trim" offset,
	-- [9] = Static Stability (C_m_alpha), - The "Spring Stiffness" of the nose,
	-- [10] = Max G-load (Structural/Limiter),
	-- [11] - [16] = (Mach tuck, ???)
-- ]]
-- -- Landing Configuration (Low Speed)
-- -- High damping (20.5) due to length.
-- -- Negative Cm0 (-0.05) reflects cambered wing pitching moment.
-- --		M,    [2],	 [3],	 [4],	  [5],	 	 [6],		[7],	 [8],	[9],	[10],	[11],	[12], 	[13],	[14],	[15],	[16]
-- -- 	  Mach   Stall  Stall   Pitch     AoA  	   Elevator		Flap	0-AoA  Static	Max		???		???		???		???		???		???
-- --			  AoA  Shrpnes Damping	 Limit	Effectivness   Moment	Moment Stablty	 G
-- [1] = {0.2,  0.26,	0.5,	20.5,	 0.35,		1.35,		0.1,	-0.05,	1.30,	2.5,	1.5,	1.2,	0.2,	0.4,	0.3,	0},

-- -- Cruise / Loiter
-- [2] = {0.4,  0.25,	0.5,	21.0,	 0.35,		1.35,		0.1,	-0.05,	1.30,	2.5,	1.5,	1.2,	0.2,	0.4,	0.3,	0},
-- [3] = {0.6,	 0.22,	0.5,	22.0,	 0.32,		1.30,		0.1,	-0.06,	1.35,	2.5,	1.5,	1.0,	0.2,	0.4,	0.3,	0},

-- -- High Speed Cruise (Mach 0.80)
-- -- Stability (Col 9) increases as center of pressure moves aft.
-- [4] = {0.8,  0.20,	0.4,	24.0,	 0.30,		1.10,		0.1,	-0.08,	1.45,	2.5,	0.8,	0.8,	0.1,	0.4,	0.3,  -0.02},

-- -- Transonic / Mach Tuck (Mach 0.86)
-- -- Cm0 (Col 8) drops to -0.25 (Mach Tuck).
-- -- Elevator Power (Col 6) drops to 0.90 (Shock formation on tail).
-- [5] = {0.86, 0.17,	0.3,	25.0,	 0.28,		0.90,		0.1,	-0.25,	1.60,	2.0,	0.5,	0.6,	0.1,	0.4,	0.3,  -0.04},

-- -- Overspeed (Mach 0.90)
-- [6] = {0.9,	 0.15,	0.2,	26.0,	 0.26,		0.60,		0.1,	-0.45,	1.80,	1.5,	0.3,	0.5,	0.1,	0.4,	0.3,  -0.06},

-- },

-- -- Pitching Moment In Ground Effect (Mz_IGE)
-- -- The 757-300 experiences a reduction in tail downforce near the ground (due to reduced downwash),
-- -- resulting in a natural NOSE DOWN pitch moment (or a reduction in nose-up authority).
-- -- This helps prevent tailstrikes but requires pilot authority to flare.
-- -- Format: {Mach, Coeff_at_h0, Coeff_at_h1...} usually, or simply an adder.
-- -- Modifications for when the plane is near the ground.
-- -- 757-300 has a long tail; ground effect reduces tail downforce -> Nose Drop tendency.
-- -- 16 Columns total
-- mz_ige_table_data =
-- {
-- --[[
	-- mz_ige_table_data columns:

	-- [1] = Mach,
	-- [2] = Stall AoA (rad) - Angle where lift/pitch linearity breaks (Stall onset),
	-- [3] = Stall Sharpness Factor - How abrupt the pitch break is after stall,
	-- [4] = Pitch Damping (C_m_q) - Resistence to rotation,
	-- [5] = Max AoA (rad) - Hard aerodynamic limit for the simulation,
	-- [6] = Elevator Effectiveness (C_m_delta-e) - Control authority,
	-- [7] = Flap/Spoiler pitch moment - Pitch change due to drag devices,
	-- [8] = Pitch Moment at 0 AoA (C_m0) - The "Trim" offset,
	-- [9] = Static Stability (C_m_alpha), - The "Spring Stiffness" of the nose,
	-- [10] = Max G-load (Structural/Limiter),
	-- [11] - [16] = (Mach tuck, ???).
-- ]]
			-- -- Simulates the loss of downwash on the tail during landing.
			-- -- Reduces Elevator Power (Col 6) to 1.05 and increases nose-down tendency (Col 8).
-- --		M,   [2],	[3],	 [4],	  [5],	 	 [6],		[7],	 [8],	[9],	[10],	[11],	[12], 	[13],	[14],	[15],  [16]
-- -- 	  Mach  Stall  Stall    Pitch     AoA  	   Elevator		Flap	0-AoA  Static	Max		???		???		???		???		???	   ???
-- --			 AoA  Shrpnes  Damping	 Limit	Effectivness   Moment	Moment Stablty	 G
-- [1] = {0.2,	0.26,	1.2,	20.5,    0.35, 		1.05,		0.1,	-0.15, 	1.30, 	2.5, 	1.5, 	1.2, 	0.2, 	0.4, 	0.3, 	0},

-- },
-- -- Rolling Moment (Mx)
-- -- Defines roll damping and aileron effectiveness limits.
-- -- Transport aircraft have high roll damping due to large wings spans.
-- -- They are sluggish compared to fighters.
-- -- 15 Columns total
-- mx_table_data =
-- {

-- --[[
	-- mx_table_data columns:

	-- [1] = Mach,
	-- [2] = Roll Sensitivity - initial roll jerk,
	-- [3] = Aileron Effectiveness (C_l_delta-a) - Maximum roll rate potential,
	-- [4] = Roll damping (C_l_p) - Resistence to rolling,
	-- [5] - [11] = ???,
	-- [12] = Max Roll Rate Limit.
-- ]]
-- --		M,   [2],	 [3],	 	[4],	[5],	[6],  	[7],	 [8],	 [9],	[10],	[11],	[12], 	 [13],	[14],	[15]
-- -- 	  Mach   Roll  Aileron		Roll  	...		???		???		 ???	 ???	???		???		???		 ???	???	  Max Roll
-- --		   Snstvty	Power	  Damping																					Rate
-- -- Low Speed: Good authority (spoilers + ailerons)
-- [1] = {0.2,  0.3, 	0.05, 		0.50, 	3.0, 	0.9, 	0.1, 	-0.05, -0.05, 	1.5, 	0.04, 	3.5, 	-0.05, 	0.4, 	1.0},

-- -- Cruise: Stiffening controls, massive damping (0.60)
-- [2] = {0.6,  0.2, 	0.04, 		0.60, 	4.0, 	0.9, 	0.1, 	-0.05, -0.05, 	1.5, 	0.04, 	2.5, 	-0.05, 	0.4, 	1.0},

-- -- High Speed: Aileron reversal risk / flexibility limits
-- [3] = {0.8,  0.1, 	0.03, 		0.65, 	4.5, 	0.9, 	0.1, 	-0.05, -0.03, 	1.5, 	0.04, 	2.0, 	-0.04, 	0.3, 	0.8},
-- [4] = {0.9,  0.1, 	0.02, 		0.70, 	5.0, 	0.9, 	0.1, 	-0.05, -0.02, 	1.5, 	0.04, 	1.5, 	-0.04, 	0.2, 	0.5},
	
-- },



        }, 
        
        engine = 
        {
            typeng  = 4,
			type 	= "TurboFan",
            
			-- For Rolls-Royce RB211-535E4B engine
            Nmg     = 63.0,     	-- N3 Idle RPM %
			Nominal_RPM = 10611,	-- 100% speed high pressure turbine (N3)
			Nominal_Fan_RPM = 4500,	-- 100% fan speed (N1)
			
            MinRUD  = 0,
            MaxRUD  = 1,
            MaksRUD = 1,
            ForsRUD = 1,
            
            hMaxEng = 13.5,    		-- Max effective engine alt [km]
            dcx_eng = 0.0095,   	-- Nacelle drag
            
            -- FUEL FLOW SFC
            -- SFC per Rolls-Royce RB211-535E4B engine
            cemax	= 0.605,     	-- [kg/kgf/h] scaled
            cefor   = 0.605,     	-- [kg/kgf/h] scaled
			
			-- Altitude compensation
			-- Standard for high-bypass turbofans to approximate
			-- thrust lapse (~30% at cruise altitude)
            dpdh_m  = 26100/2,		-- [N/km per engine]
            dpdh_f  = 26100/2,
            
            table_data = 
            {
                -- THRUST TABLE (2x RB211-535E4B)
				-- Static: ~383,400 N Total
				-- CORRECTED: RB211-535 curve
				--    Mach,    Newtons,  Newtons (Afterburner)
				[1] = {0.0,    383400,     383400},
				[2] = {0.2,    382000,     382000},
				[3] = {0.4,    380000,     380000},
				[4] = {0.6,    378000,     378000},
				[5] = {0.8,    375000,     375000}, -- Cruise Base (Net ~88kN at FL350)
				[6] = {0.86,   360000,     360000},
				[7] = {0.9,    300000,     300000},
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
        [1] = "B_757-OBLOMOK-WING-R",
        [2] = "B_757-OBLOMOK-WING-L",
    },

    -- ===================================================================
    -- LIGHTS
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
                            typename = "Spot", position = { -24.989025, 0.892547, 0 },
							direction = {azimuth = math.rad(180.0)},
                            proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(180.0), angle_min = math.rad(170.0),
                        },
						{
							typename = "Omni", position = { -24.989025, 0.892547, 0 },
							proto = lamp_prototypes.ANO_3_Bl, movable = true,
						},
						{
							typename = "Spot", position = { -3.713652, 0.004093, -18.803585 },
							direction = {azimuth = math.rad(-60.0), elevation = math.rad(0)},
							proto = lamp_prototypes.BANO_8M_red, angle_max = math.rad(120.0), angle_min = math.rad(0),
						},
						{
							typename = "Spot", position = { -3.714065, 0.003592, 18.803144 },
							direction = {azimuth = math.rad(60.0), elevation = math.rad(0)},
							proto = lamp_prototypes.BANO_8M_green, angle_max = math.rad(120.0), angle_min = math.rad(0),
						},
						
						{	-- port empennage logo illumination. Source: https://www.jetphotos.com/photo/9445752
                            typename = "Spot",  position = { -23.000, 0.300, -4.00 },
							direction = {azimuth = math.rad(70.0), elevation = math.rad(-52.0)}, 
                            proto = lamp_prototypes.FR_100, intensity_max = 120.0, angle_max = math.rad(80.0), angle_min = math.rad(0.0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.2, movable = true,
                        },
						{	-- starboard empennage logo illumination. Source: https://www.jetphotos.com/photo/9445752
                            typename = "Spot",  position = { -23.000, 0.300, 4.00 },
							direction = {azimuth = math.rad(-70.0), elevation = math.rad(-52.0)}, 
                            proto = lamp_prototypes.FR_100, intensity_max = 120.0, angle_max = math.rad(80.0), angle_min = math.rad(0.0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.2, movable = true,
                        },
						
						-- Wing illumination.
						{
							typename = "Spot",  position = { 10.70, 0.800, -2.20 },
							direction = {azimuth = math.rad(-138.0), elevation = math.rad(1.0)},
							proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0.0),
							cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
						{
							typename = "Spot",  position = { 10.70, 0.800, 2.20 },
							direction = {azimuth = math.rad(138.0), elevation = math.rad(1.0)},
							proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0.0),
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
							typename = "Spot", position = { 21.752508, -3.120416, 0.000165 }, argument = 51,
							direction = {azimuth = math.rad(0.0), elevation = math.rad(5.0)},
							proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(21.0), angle_min = math.rad(0),
							cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
						},
						{
                            typename = "Spot",  position = { 6.700, -1.300, -2.750 },
							direction = {azimuth = math.rad(-7.0), elevation = math.rad(3.0)},
                            proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 6.700, -1.300, 2.750 },
							direction = {azimuth = math.rad(7.0), elevation = math.rad(3.0)},
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
							typename = "Spot", position = { 21.752508, -3.120416, 0.000165 }, argument = 51,
							direction = {azimuth = math.rad(0.0), elevation = math.rad(4.0)},
							proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(33.0), angle_min = math.rad(0),
							cool_down_t = 0.5, movable = true,
						},
						{
							typename = "Omni", position = { 21.852508, -3.120416, 0.000165 },
							proto = lamp_prototypes.LFS_R_27_450, range = 6.0, movable = true,
						},
						{
                            typename = "Spot",  position = { 6.700, -1.300, -2.750 },
							direction = {azimuth = math.rad(-10.0), elevation = math.rad(4.0)},
                            proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(30.0), angle_min = math.rad(0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 6.700, -1.300, 2.750 },
							direction = {azimuth = math.rad(10.0), elevation = math.rad(4.0)},
                            proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(30.0), angle_min = math.rad(0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						
						-- Runway turnoff lights. These really ought to be animated as part of the wheel steering mechanism, but I don't know how to do that.
						{
                            typename = "Spot",  position = { 17.300, -2.200, -1.700 },
							direction = {azimuth = math.rad(-50.0), elevation = math.rad(5.0)},
                            proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(45.0), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						{
                            typename = "Spot",  position = { 17.300, -2.200, 1.700 },
							direction = {azimuth = math.rad(50.0), elevation = math.rad(5.0)},
                            proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(45.0), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                    },
                },
            },
        },
		
		[WOLALIGHT_BEACONS] = {			-- For moving around on the ground/taxiing.
			-- Source: https://commons.wikimedia.org/wiki/File:Boeing_757-225,_Atlasjet_International_Airways_AN0450402.jpg
            typename = "collection",
            lights = {
                [1] = {
                    typename = "Collection",
                    lights = {
                        {
                            typename = "natostrobelight", position = { 15.5, 1.800, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 1.30, -3.10, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
                    },
                },
            },
        },
		
        [WOLALIGHT_STROBES] = {			-- For moving around on/near the runway (including airborne).
			-- Source: https://commons.wikimedia.org/wiki/File:Boeing_757-225,_Atlasjet_International_Airways_AN0450402.jpg
            typename = "collection",
            lights = {
                [1] = {
                    typename = "Collection",
                    lights = {
                        {
                            typename = "natostrobelight", position = { 15.5, 1.800, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 1.30, -3.10, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
						
						{
                            typename = "Spot", position = { -3.713652, 0.004093, -18.803585 },
                            controller = "VariablePatternStrobe", mode = "1 Flash",
							proto = lamp_prototypes.MPS_1, intensity_max = 600.0, period = 0.333, phase_shift = 0.25,
							direction = {azimuth = math.rad(-90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
                        {
                            typename = "Spot", position = { -3.714065, 0.003592, 18.803144 },
                            controller = "VariablePatternStrobe", mode = "1 Flash",
							proto = lamp_prototypes.MPS_1, intensity_max = 600.0, period = 0.333, phase_shift = 0.25,
							direction = {azimuth = math.rad(90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
						{
                            typename = "Spot", position = { -24.989025, 0.892547, 0 },
                            controller = "VariablePatternStrobe", mode = "1 Flash",
							proto = lamp_prototypes.MPS_1, intensity_max = 600.0, period = 0.333, phase_shift = 0.25,
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
                            typename = "natostrobelight", position = { 15.5, 1.800, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { 1.30, -3.10, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
					},
				},
			},
		},
	},
	},
}

add_aircraft(B_757)