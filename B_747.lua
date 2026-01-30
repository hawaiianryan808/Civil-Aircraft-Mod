-- ===================================================================
-- BOEING 747-400F PERFORMANCE DEFINITION
-- ===================================================================
--[[
CHANGE LOG & IMPLEMENTATION NOTES (CONVERSION TO 747-400F):

1. IDENTITY:
   - Updated to B-747-400F.
   - Introduction date updated to 1993 (Entry into service of Freighter).

2. DIMENSIONS:
   - Wing Span: Increased to 64.44m (Winglets).
   - Wing Area: Increased to 560 m^2.

3. MASS AND FUEL:
   - M_max (MTOW): Increased to 396,890 kg (875,000 lbs standard).
   - M_fuel_max: Increased to 172,500 kg (Reflects larger capacity of -400).
   - M_empty: Adjusted to 178,000 kg (Reinforced freighter floor vs Pax interior).

4. PROPULSION (GE CF6-80C2B1F):
   - Thrust: Increased to 1,104 kN Total (4x ~62,000 lbf).
   - Efficiency: Improved fuel consumption parameters (High-bypass turbofans).

5. CREW:
   - Reduced crew_size to 2 (Digital Glass Cockpit, no Flight Engineer).
--]]


B_747 =  {
    -- ===================================================================
    -- 1. IDENTITY & ASSETS
    -- ===================================================================
    Name                = 'B_747', -- Internal name often stays same to link to existing shapes/cockpits if no new mod exists
    DisplayName         = _('B747-400F'),
    date_of_introduction= 1993.11,
    Picture             = "B-747.png",
    Rate                = "50", -- Slightly higher rate for modern heavy
    Shape               = "B_747",
    WorldID             = WSTYPE_PLACEHOLDER,
    defFuelRatio        = 0.6, -- Freighters often fly lighter fuel loads for max payload
    singleInFlight      = true,

    mapclasskey         = "P0091000029",
    attribute           = {wsType_Air, wsType_Airplane, wsType_Cruiser, WSTYPE_PLACEHOLDER, "Transports",},
    Categories          = {},

    shape_table_data    =
    {
        {
            file        = 'B_747',
            life        = 25, -- Increased structural toughness
            vis         = 3,
            desrt       = 'kc-135-oblomok',
            fire        = { 300, 2},
            username    = 'B_747',
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

    -- ===================================================================
    -- 2. DIMENSIONS & GEOMETRY
    -- ===================================================================
    -- Dimensions (Updated for -400F)
	-- The DCS model is undersized, so these dimensions will reflect the
	-- 3D model instead or less because DCS's spawn volume limits are stupid.
    length      = 65.0,		-- [m] (Actual 231 ft 10 in - 70.6m) - Limited because DCS is stupid
    height      = 12.4,		-- [m] (Actual 63 ft 8 in - 19.4m) - Limited because DCS is stupid
    wing_area   = 560,   	-- [m^2] (Increased for -400 wing) https://www.airliners.net/aircraft-data/boeing-747-400/100 https://www.aviatorjoe.net/go/compare/747-400F/747-8F/
    wing_span   = 59.44,	-- [m] (64.44m real-world)

    -- Gear Geometry
    wing_tip_pos    = 	{-13.89, -0.16,  29.64},

    nose_gear_pos 	= 	{24.606, -6.035, 0}, 			-- Nose gear position (ground under center of the axle)

	main_gear_pos 	= 	{-2.45,  -6.013, 6.325},		-- Main gear position (ground under center of the axle)
														-- automatically mirrored

	nose_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (arg 2)
	nose_gear_amortizer_reversal_stroke 	 = -0.4184,	-- Full Strut Compression (maximum+ weight on wheels)
	nose_gear_amortizer_normal_weight_stroke = -0.189,	-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	nose_gear_wheel_diameter				 =  1.272,	-- Diameter of the nose gear wheel (meters)

	main_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (args 4 and 6)
	main_gear_amortizer_reversal_stroke 	 = -0.1451,	-- Full Strut Compression (maximum+ weight on wheels)
	main_gear_amortizer_normal_weight_stroke = -0.0696,	-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	main_gear_wheel_diameter 				 =  1.349,	-- Diameter of the main gear wheels (meters)

    tand_gear_max   =   math.tan(math.rad(70)),

    -- ===================================================================
    -- 3. MASS & FUEL
    -- ===================================================================
    -- Mass Parameters (UPDATED for -400F)
    M_empty     = 163750,  -- [kg] (OEW for 747-400F is ~361,000 lbs)
    M_nominal   = 360000,  -- [kg] (Increased typical takeoff weight)
    M_max       = 396890,  -- [kg] (MTOW: 875,000 lbs standard for 400F)
    M_fuel_max  = 173950,  -- [kg] (~216,846 Liters @ 0.803 kg/L)

    -- Fuel Consumption (AI & General)
    -- Cruise fuel flow is ~11,500–12,000 kg/h total / ~3.2 kg/s
    average_fuel_consumption = 3.2, -- [kg/sec] total


	-- ===================================================================
    -- INERTIA & CG (B747-400F)
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
	-- Nominal (Loaded ~25% MAC)
    -- Center of Mass (Relative to Model Origin)
    -- Rear-most Trunnion (Body Gear) is at x = -1.646
    -- CG set to 1.50 to provide ~3.15m static margin forward of the pivot.
    center_of_mass      = {1.50, -1.80, 0.0},				-- [m] CG w.r.t. EDM 3D mesh origin in TsAGI coordinate order

--[[
	B747-400F MOI and POI (EMPTY configuation) in TsAGI coordinate system.
 
	POI sign check:
	The 747 has four heavy, podded engines located below the wing (-Y in TsAGI) and
	generally forward of the Center of Gravity (+X), while the empennage/tail (-X)
	structure is high (+Y). The sum of those products should be NEGATIVE.
	
]]
	moment_of_inertia	= {53.3e6, 130.7e6, 118e6, -2.1e6},	-- [kg*m^2] {Roll, Yaw, Pitch, POI}


    -- ===================================================================
    -- 4. FLIGHT PERFORMANCE
    -- ===================================================================
    -- Altitude & Range
    H_max               = 13750,   -- [m] (Service ceiling 45,100 ft)
    range               = 8230,    -- [km] (Real max range with typical payload
								   --        is ~4,445 nm / 8,230 km, as per
								   --        Boeing and Cargolux specs)

    -- Speeds (UPDATED for Mach 0.85 Cruise)
    V_opt               = 257,  -- [m/s TAS] (Mach 0.85 cruise at FL350)
    V_take_off          = 90,   -- [m/s TAS] (Higher MTOW requires slightly higher V2)
    V_land              = 76,   -- [m/s TAS] (~148 kts, typical Vref at max landing weight)
    V_max_sea_level     = 194.5,-- [m/s TAS] (Vmo limited by structure)
    V_max_h             = 265,  -- [m/s TAS] (Mach 0.92 MMO)
    CAS_min             = 75,   -- [m/s TAS] 
    Mach_max            = 0.92, -- MMO

    -- Climb
    Vy_max              = 10.0, -- [m/s] (Initial climb rate at MTOW is ~1,500–2,000 fpm / ~7.6–10.2 m/s based on SKYbrary)

    -- Limits
    Ny_min      		= -1.52,-- [G]
    Ny_max      		= 2.0,	-- [G]
    Ny_max_e   			= 2.5,	-- [G]
    bank_angle_max      = 35,   -- Modern flight computers allow slightly more aggressive banking
    AOA_take_off        = math.rad(10),

    -- ===================================================================
    -- 5. ENGINE DEFINITIONS
    -- ===================================================================
    engines_count       = 4,
    has_afteburner      = false,
    has_thrustReverser  = true,

    -- Thrust Parameters (4x GE CF6-80C2B1F)
    -- Approx 57,900 lbf per engine = 257.55 kN
    -- Total Static Thrust: 1,030,200 N
    thrust_sum_max      = 105051, -- [kgf] (Significant increase over -200)
    thrust_sum_ab       = 105051, -- [kgf] (No AB)

    engines_startup_sequence = { 3, 2, 1, 0 },	-- Often started in pairs or 4-3-2-1
    engines_nozzles =
    {
        [1] = 	-- Left outboard
        {
            pos =   {-4.2,	-2.96,	-21.121},
            elevation			=  	-2.25,	-- 2-2.5 degree exhaust depression (negative means exhaust points down)
			azimuth             = 	2.0,	-- 2.0 degree toe-in (positive means thrust vector points toward longitudinal axis; exhaust points away)
            diameter    		=   0.755,
            exhaust_length_ab   =   9,
            exhaust_length_ab_K =   0.76,
            smokiness_level     =   0.01,	-- Newer engines are cleaner
			engine_number       = 	1,
        },
        [2] = 	-- Left inboard
        {
            pos =   {3.922,	-3.537,	-12.119},
            elevation			=  	-2.25,	-- 2-2.5 degree exhaust depression (negative means exhaust points down)
			azimuth             = 	2.0,	-- 2.0 degree toe-in (positive means thrust vector points toward longitudinal axis; exhaust points away)
            diameter    		=   0.755,
            exhaust_length_ab   =   9,
            exhaust_length_ab_K =   0.76,
            smokiness_level     =   0.01,
			engine_number       = 	2,
        },
        [3] = 	-- Right inboard
        {
            pos =   {3.922,	-3.537,	12.119},
            elevation			=  	-2.25,	-- 2-2.5 degree exhaust depression (negative means exhaust points down)
			azimuth             =  -2.0,	-- 2.0 degree toe-in (negative means thrust vector points toward longitudinal axis; exhaust points away)
            diameter    		=   0.755,
            exhaust_length_ab   =   9,
            exhaust_length_ab_K =   0.76,
            smokiness_level     =   0.01,
			engine_number       = 	3,
        },
        [4] = 	-- Right outboard
        {
            pos =   {-4.2,	-2.96,	21.121},
            elevation			=  	-2.25,	-- 2-2.5 degree exhaust depression (negative means exhaust points down)
			azimuth             =  -2.0,	-- 2.0 degree toe-in (negative means thrust vector points toward longitudinal axis; exhaust points away)
            diameter    		=   0.755,
            exhaust_length_ab   =   9,
            exhaust_length_ab_K =   0.76,
            smokiness_level     =   0.01,
			engine_number       = 	4,
        },
    },

    -- ===================================================================
    -- 6. SYSTEMS, CREW & EQUIPMENT
    -- ===================================================================
    crew_size               = 2, 	-- UPDATED: 747-400 has no Flight Engineer
    RCS                     = 120, 	-- [m^2] Large physical dimensions dominate over frequency resonance
    radar_can_see_ground    = false,-- Plane cannot detect ground units
    detection_range_max		= 30,	-- [km] Distance pilots in this airframe can possibly become aware of other airframes
    IR_emission_coeff       = 3.4, 	-- Four large engines. The sheer quantity of hot gas generates a massive broad-spectrum signature.

    -- Aircraft Specifics
    tanker_type                 = 0,
    is_tanker                   = false,
    has_speedbrake              = true,
    has_differential_stabilizer = false,
    flaps_transmission          = "Hydraulic",
    undercarriage_transmission  = "Hydraulic",
    flaps_maneuver              = 20/30,	-- Corresponds to Flaps 20; Flaps 30 for landing
    brakeshute_name             = 0,
    stores_number               = 0,

    crew_members =
    {
        [1] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {26.41, 3.035, -0.62}, }, -- Pilot
        [2] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {26.41, 3.035,  0.62}, }, -- Co-Pilot
    },

    CanopyGeometry = {
        azimuth = {-110.0, 110.0},
        elevation = {-30.0, 60.0},
    },

    HumanRadio = {
        frequency       = 127.5,
        editable        = true,
        minFrequency    = 118.000,
        maxFrequency    = 137.000,
        modulation      = MODULATION_AM
    },

    Failures = {
        { id = 'asc',       label = _('ASC'),       enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'autopilot', label = _('AUTOPILOT'), enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'hydro',     label = _('HYDRO'),     enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'l_engine',  label = _('L-ENGINE'),  enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
        { id = 'r_engine',  label = _('R-ENGINE'),  enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
    },

    Pylons = {},
    Tasks = { aircraft_task(Transport), },
    DefaultTask = aircraft_task(Transport),

    -- ===================================================================
    -- 7. SFM DATA (AERODYNAMICS & ENGINE SIMULATION)
    -- ===================================================================
    SFM_Data = {
        aerodynamics = {
            -- Control authority parameters
            Cy0         = 0.10,     -- Positive lift at zero AoA
            Mzalfa      = 4.5,      -- Pitch stability
            Mzalfadt    = 1.0,      -- Pitch damping
            kjx         = 3.1,      -- Higher Roll Inertia (heavier wings/fuel)
            kjz         = 0.0014,   -- Pitch inertia
            Czbe        = -0.018,   -- Directional stability

            -- Drag coefficients
            cx_gear     = 0.045,    -- Gear drag increment (from paper initial climb)
            cx_flap     = 0.06,     -- Flap drag
            cy_flap     = 0.50,     -- Flap lift
            cx_brk      = 0.05,     -- Speedbrake drag (estimated)

            table_data = {
				-- Aerodynamic Drag Polar Table
				-- M: Mach, Cx0: Zero-lift drag, Cya: Normal force coeff, B/B4: Polar shape
				-- Omxmax: Roll rate, Aldop: Max AoA, Cymax: Max Lift
				-- 		M       Cx0      Cya      B        B4    Omxmax   Aldop   Cymax
				-- REVISION for -400F: Slightly lower form drag Cx0

				-- Low Speed
				[1]  = {0.0,   0.015,  0.095,   0.033,   0.001,   0.35,   13,     1.45},
				[2]  = {0.2,   0.015,  0.095,   0.033,   0.001,   0.45,   13,     1.45},
				[3]  = {0.4,   0.016,  0.095,   0.033,   0.002,   0.45,   12.5,   1.45},

				-- Climb
				[4]  = {0.6,   0.018,  0.093,  0.038,    0.01,    0.50,   15,     1.40},

				-- Cruise (Mach 0.82 - 0.86 typical)
				[5]  = {0.7,   0.022,  0.092,  0.043,    0.02,    0.50,   14,     1.30},
				[6]  = {0.8,   0.024,  0.091,  0.046,    0.03,    0.50,   14.0,   1.15},
				[7]  = {0.84,  0.032,  0.090,  0.048,    0.03,    0.45,   13,     1.20},

				-- Mach Limit
				[8]  = {0.88,  0.055,  0.105,  0.170,    0.100,   0.7,    11.0,   0.80},
				[9]  = {0.9,   0.120,  0.087,  0.290,    0.200,   0.5,    12,     1.00},
				[10] = {1.0,   0.350,  0.085,  0.490,    0.300,   0.3,    8.0,    0.40},
            },


-- BOEING 747-400F AERODYNAMIC TABLES
-- Calibrated for High Inertia, Transonic Cruise (M0.85), and Heavy Weight Ops.

mz_table_data = {
--[[
	PITCHING MOMENT COEFFICIENT (Mz)
	
	mz_table_data columns:
	
	[1] = Mach,
	[2] = Stall AoA (rad) - Angle where lift/pitch linearity breaks (Stall onset),
	[3] = Stall sharpness factor - How abrupt the pitch break is after stall,
	[4] = Pitch damping (C_m_q) - Resistence to rotation,
	[5] = Max AoA (rad) - Hard aerodynamic limit for the simulation,
	[6] = Elevator Effectiveness (C_m_delta-e) - Control authority,
	[7] = Flap/Spoiler pitch moment - Pitch change due to drag devices,
	[8] = Pitch moment at 0 AoA (C_m0) - The "Trim" offset,
	[9] = Static Stability (C_m_alpha), - The "Spring Stiffness" of the nose,
	[10] = Max G-load (Structural/Limiter),
	[11] - [16] = (Mach tuck, ???)
]]

-- Low Speed (Landing/Takeoff)
-- High damping (22.0) due to length.
-- Negative Cm0 (-0.06) reflects cambered wing pitching moment.
--		M,    [2],	 [3],	 [4],	  [5],	 	 [6],		[7],	 [8],		 [9],	[10],	[11],	[12], 	[13],	[14],	[15],	[16]
-- 	  Mach   Stall  Stall   Pitch     AoA  	   Elevator		Flap	0-AoA	   Static	Max		???		???		???		???		???		???
--			  AoA  Shrpnes Damping	 Limit	Effectivness   Moment	Moment	   Stablty	 G
[1] = {0.2,  0.24,	0.5,	22.0,	 0.35,		1.25,		0.1,	-0.06,		1.20,	2.5,	1.5,	1.2,	0.2,	0.4,	0.3,	0},

-- Cruise / Loiter
[2] = {0.4,  0.24,	0.5,	22.0,	 0.35,		1.30,		0.1,	-0.06,		1.25,	2.5,	1.5,	1.2,	0.2,	0.4,	0.3,	0},
[3] = {0.6,	 0.22,	0.5,	23.0,	 0.32,		1.30,		0.1,	-0.07,		1.30,	2.5,	1.5,	1.0,	0.2,	0.4,	0.3,	0},

-- High Speed Cruise (Mach 0.84 - 0.86)
-- Stability (Col 9) increases to 1.50 as center of pressure moves aft.
[4] = {0.8,  0.20,	0.4,	25.0,	 0.30,		1.10,		0.1,	-0.09,		1.50,	2.5,	0.8,	0.8,	0.1,	0.4,	0.3,  -0.02},

-- Transonic / Mach Tuck (Mach 0.88+)
-- Cm0 (Col 8) drops to -0.20 (Mach Tuck).
-- Elevator Power (Col 6) drops to 0.80 (Shock formation on tail).
[5] = {0.88, 0.16,	0.3,	26.0,	 0.28,		0.80,		0.1,	-0.20,		1.70,	2.0,	0.5,	0.6,	0.1,	0.4,	0.3,  -0.05},

-- Overspeed (Mach 0.92 MMO)
[6] = {0.92, 0.14,	0.2,	28.0,	 0.26,		0.50,		0.1,	-0.40,		1.90,	1.5,	0.3,	0.5,	0.1,	0.4,	0.3,  -0.08},

},


mz_ige_table_data = {
--[[
	PITCHING MOMENT IN GROUND EFFECT (Mz_IGE)
	Simulates the loss of downwash on the tail during landing.

	mz_ige_table_data columns:

	[1] = Mach,
	[2] = Stall AoA (rad) - Angle where lift/pitch linearity breaks (Stall onset),
	[3] = Stall Sharpness Factor - How abrupt the pitch break is after stall,
	[4] = Pitch Damping (C_m_q) - Resistence to rotation,
	[5] = Max AoA (rad) - Hard aerodynamic limit for the simulation,
	[6] = Elevator Effectiveness (C_m_delta-e) - Control authority,
	[7] = Flap/Spoiler pitch moment - Pitch change due to drag devices,
	[8] = Pitch Moment at 0 AoA (C_m0) - The "Trim" offset,
	[9] = Static Stability (C_m_alpha), - The "Spring Stiffness" of the nose,
	[10] = Max G-load (Structural/Limiter),
	[11] - [16] = (Mach tuck, ???).
]]

-- Reduces Elevator Power (Col 6) to 0.95 and increases nose-down tendency (Col 8).
--		M,   [2],	[3],	 [4],	  [5],	 	 [6],		[7],	 [8],		[9],	[10],	[11],	[12], 	[13],	[14],	[15],  [16]
-- 	  Mach  Stall  Stall    Pitch     AoA  	   Elevator		Flap	0-AoA	   Static	Max		???		???		???		???		???	   ???
--			 AoA  Shrpnes  Damping	 Limit	Effectivness   Moment	Moment 	   Stablty	 G
[1] = {0.2,	0.24,	1.2,	22.0,    0.35, 		0.95,		0.1,	-0.18,		1.20, 	2.5, 	1.5, 	1.2, 	0.2, 	0.4, 	0.3, 	0},

},


mx_table_data = {
--[[
	ROLLING MOMENT (Mx)
	
	High roll damping (Col 4) due to 64m wingspan.
	Max Roll Rate (Col 12) limited to ~0.3-0.4 rad/s (~20 deg/s).

	mx_table_data columns:

	[1] = Mach,
	[2] = Roll Sensitivity - initial roll jerk,
	[3] = Aileron Effectiveness (C_l_delta-a) - Maximum roll rate potential,
	[4] = Roll damping (C_l_p) - Resistence to rolling,
	[5] - [14] = ???,
	[15] = Max Roll Rate Limit.
]]

--		M,    [2],	   [3],	 	[4],	[5],	[6],  	[7],	 [8],	  [9],	[10],	[11],	[12], 	 [13],	[14],	[15]
-- 	  Mach    Roll   Aileron	Roll  	???		???		???		 ???	  ???	???		???		???		 ???	???	  Max Roll
--		    Snstvty	  Power	  Damping																					Rate

-- Low Speed: Spoilers + Inboard/Outboard Ailerons active.
[1] = {0.2,  0.20, 	  0.04,    0.70, 	3.0, 	0.9, 	0.1, 	-0.05, 	-0.05, 	1.5, 	0.04, 	0.40, 	-0.05, 	0.4, 	1.0},

-- Cruise: Outboard ailerons locked out. Stiff controls.
[2] = {0.6,  0.15, 	  0.03,    0.75, 	4.0, 	0.9, 	0.1, 	-0.05,	-0.05, 	1.5, 	0.04, 	0.30, 	-0.05, 	0.4, 	1.0},

-- High Speed: Aeroelastic twisting limits effectiveness.
[3] = {0.8,  0.10, 	  0.02,    0.80, 	4.5, 	0.9, 	0.1, 	-0.05,	-0.03, 	1.5, 	0.04, 	0.25, 	-0.04, 	0.3, 	0.8},
[4] = {0.9,  0.10, 	  0.015,   0.85, 	5.0, 	0.9, 	0.1, 	-0.05,	-0.02, 	1.5, 	0.04, 	0.20, 	-0.04, 	0.2, 	0.5},

},


        },	-- end of aerodynamics tables

        engine = {
			-- ===================================================================
			-- ENGINE CONFIGURATION (GE CF6-80C2B1F)
			-- ===================================================================

            typeng  = 4,
			type	= "TurboFan",

            -- RPM and throttle
            Nmg     = 62.5,     		-- N2 Idle RPM %
            Nominal_RPM = 10850.0,   	-- N2 100% RPM
            Nominal_Fan_RPM = 3650.0,	-- N1 100% RPM

            MinRUD  = 0,
            MaxRUD  = 1,
            MaksRUD = 1,
            ForsRUD = 1,

            -- Altitude and drag
            hMaxEng = 15.5,     -- Modern engines sustain combustion higher
            dcx_eng = 0.0125,   -- Larger nacelles (higher drag)

            -- FUEL CONSUMPTION (Specific Fuel Consumption - SFC - per engine)
			-- CF6-80C2B1F TSFC is approx 0.307 (Cruise) to 0.56 (Takeoff) lb/lbf/hr
			-- DCS Units: [kg / kgf / h]
			-- Converted: 0.307 lb/lbf/hr ≈ 0.307 kg/kgf/hr (Units are roughly 1:1)
			-- We use a blended value for the simple model.
            cemax   = 0.560,	-- [kg/kgf/h]
            cefor   = 0.560,	-- [kg/kgf/h]

            -- Thrust lapse for high-bypass turbofans
            dpdh_m  = 30000,	-- [N/km per engine]
            dpdh_f  = 30000,

            table_data = {
                -- THRUST TABLE (4x CF6-80C2B1F)
				-- Total Thrust Sum [Newtons] vs Mach Number
				-- 1 Engine = ~257,550 N (57,900 lbf)
				-- 4 Engines = ~1,030,200 N
				--      Mach      Thrust(N)    Thrust_AB(N)
				[1] =   {0.0,     1030200,     1030200},   -- Static Takeoff
				[2] =   {0.2,     985000,      985000},    -- Initial Climb
				[3] =   {0.4,     920000,      920000},
				[4] =   {0.6,     850000,      850000},

				-- Cruise Range (Lapse is handled by dpdh_m, this is Mach efficiency)
				[5] =   {0.7,     780000,      780000},
				[6] =   {0.8,     720000,      720000},    -- Cruise Baseline
				[7] =   {0.85,    680000,      680000},

				-- High Speed / Choke
				[8] =   {0.9,     550000,      550000},    -- Inlet recovery loss
				[9] =   {0.95,    400000,      400000},
            },
        },
    },

    -- ===================================================================
    -- 8. DAMAGE & FAILURES
    -- ===================================================================
    -- (Kept identical to base model for compatibility with 747 shapes)
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
        [1] = "B_747-OBLOMOK-WING-R",
        [2] = "B_747-OBLOMOK-WING-L",
    },

    fires_pos =
    {
        [1] =   {-0.138,    -0.79,  0},
        [2] =   {-0.138,    -0.79,  5.741},
        [3] =   {-0.138,    -0.79,  -5.741},
        [4] =   {-0.82,     0.265,  2.774},
        [5] =   {-0.82,     0.265,  -2.774},
        [6] =   {-0.82,     0.255,  4.274},
        [7] =   {-0.82,     0.255,  -4.274},
        [8] =   {-0.347,    -1.875, 8.138},
        [9] =   {-0.347,    -1.875, -8.138},
        [10] =  {-5.024,    -1.353, 13.986},
        [11] =  {-5.024,    -1.353, -13.986},
    },

    -- ===================================================================
    -- 9. LIGHTS DEFINITION
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
                            typename = "Spot", position = { -34.262684, 2.350242, 0 },
							direction = {azimuth = math.rad(180.0), elevation = math.rad(0.0)},
                            proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(140.0), angle_min = math.rad(0.0),
                        },
						{
							typename = "Omni", position = { -34.262684, 2.350242, 0 },
							proto = lamp_prototypes.ANO_3_Bl, movable = true,
						},
                        {
                            typename = "Spot", position = { -11.358561, -0.081693, -29.7552 },
							direction = {azimuth = math.rad(-55.0), elevation = math.rad(0.0)},
                            proto = lamp_prototypes.BANO_8M_red, angle_max = math.rad(110.0), angle_min = math.rad(0.0),
                        },
                        {
                            typename = "Spot", position = { -11.358136, -0.081694, 29.7551 },
							direction = {azimuth = math.rad(55.0), elevation = math.rad(0.0)},
                            proto = lamp_prototypes.BANO_8M_green, angle_max = math.rad(110.0), angle_min = math.rad(0.0),
                        },

						{	-- port empennage logo illumination. Source: https://commons.wikimedia.org/wiki/File:Boeing_747_navigation_lights.svg
                            typename = "Spot",  position = { -30.000, 2.500, -5.00 },
							direction = {azimuth = math.rad(80.0), elevation = math.rad(-47.0)},
                            proto = lamp_prototypes.FR_100, intensity_max = 120.0, angle_max = math.rad(80.0), angle_min = math.rad(0.0),
                            exposure = {{0, 0.9, 1.0}}, power_up_t = 0.25, cool_down_t = 0.2, movable = true,
                        },
						{	-- starboard empennage logo illumination. Source: https://commons.wikimedia.org/wiki/File:Boeing_747_navigation_lights.svg
                            typename = "Spot",  position = { -30.000, 2.500, 5.00 },
							direction = {azimuth = math.rad(-80.0), elevation = math.rad(-47.0)},
                            proto = lamp_prototypes.FR_100, intensity_max = 120.0, angle_max = math.rad(80.0), angle_min = math.rad(0.0),
                            exposure = {{0, 0.9, 1.0}}, power_up_t = 0.25, cool_down_t = 0.2, movable = true,
                        },

						-- Wing illumination.
						{
                            typename = "Spot",  position = { 19.000, 1.000, -3.20 },
							direction = {azimuth = math.rad(-140.0), elevation = math.rad(5.0)},
                            proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(30.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.5, movable = true,
                        },
						{
                            typename = "Spot",  position = { 19.000, 1.000, 3.20 },
							direction = {azimuth = math.rad(140.0), elevation = math.rad(5.0)},
                            proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(30.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.5, movable = true,
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
                            typename = "Spot", position = { 29.000, -4.000, 0.000 },
							direction = {elevation = math.rad(8.0)}, argument = 51,
                            proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(25.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },

						-- Inboard landing lights.
                        {
                            typename = "Spot",  position = { 10.500, -1.200, -5.500 },
							direction = {azimuth = math.rad(-5.0), elevation = math.rad(8.0)},
                            proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 10.500, -1.200, 5.500 },
							direction = {azimuth = math.rad(5.0), elevation = math.rad(8.0)},
                            proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },

						-- Outboard landing lights: https://www.cpat.com/courses/boeing-747-400/747-400-interactive-aircraft-systems-diagrams/
                        {
                            typename = "Spot",  position = { 10.500, -1.200, -6.000 },
							direction = {azimuth = math.rad(-15.0), elevation = math.rad(8.0)},
                            proto = lamp_prototypes.LFS_P_27_1000, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 10.500, -1.200, 6.000 },
							direction = {azimuth = math.rad(15.0), elevation = math.rad(8.0)},
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
                            typename = "Spot",  position = { 25.000, -4.000, 0.000 },
							direction = {azimuth = math.rad(0.0), elevation = math.rad(4.0)}, argument = 51,
                            proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(33.3), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },

						-- Inboard taxis lights.
                        {
                            typename = "Spot",  position = { 7.500, -1.200, -5.500 },
							direction = {azimuth = math.rad(-8.0), elevation = math.rad(4.0)},
                            proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(30.0), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 7.500, -1.200, 5.500 },
							direction = {azimuth = math.rad(8.0), elevation = math.rad(4.0)},
                            proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(30.0), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },

						-- Outboard taxi lights
                        {
                            typename = "Spot",  position = { 10.500, -1.200, -6.000 },
							direction = {azimuth = math.rad(-30.0), elevation = math.rad(7.0)},
                            proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(30.0), angle_min = math.rad(0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 10.500, -1.200, 6.000 },
							direction = {azimuth = math.rad(30.0), elevation = math.rad(7.0)},
                            proto = lamp_prototypes.LFS_R_27_450, angle_max = math.rad(30.0), angle_min = math.rad(0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                    },
                },
            },
		},

        [WOLALIGHT_BEACONS] = {		-- For moving around on the ground/taxiing.
			-- Source: https://commons.wikimedia.org/wiki/File:Boeing_747_navigation_lights.svg
            typename = "collection",
            lights = {
                [1] = {
                    typename = "Collection",
                    lights = {
                        {
                            typename = "natostrobelight", position = { 17.0, 5.0, 0.000},
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { -17.0, -3.0, 0.000},
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },

						{	-- port empennage logo illumination. Source: https://commons.wikimedia.org/wiki/File:Boeing_747_navigation_lights.svg
                            typename = "Spot",  position = { -30.000, 2.500, -5.00 },
							direction = {azimuth = math.rad(80.0), elevation = math.rad(-47.0)},
                            proto = lamp_prototypes.FR_100, intensity_max = 100.0, angle_max = math.rad(80.0), angle_min = math.rad(0.0),
                            exposure = {{0, 0.9, 1.0}}, power_up_t = 0.25, cool_down_t = 0.2, movable = true,
                        },
						{	-- starboard empennage logo illumination. Source: https://commons.wikimedia.org/wiki/File:Boeing_747_navigation_lights.svg
                            typename = "Spot",  position = { -30.000, 2.500, 5.00 },
							direction = {azimuth = math.rad(-80.0), elevation = math.rad(-47.0)},
                            proto = lamp_prototypes.FR_100, intensity_max = 100.0, angle_max = math.rad(80.0), angle_min = math.rad(0.0),
                            exposure = {{0, 0.9, 1.0}}, power_up_t = 0.25, cool_down_t = 0.2, movable = true,
                        },
                    },
                },
            },
        },

		[WOLALIGHT_STROBES] = {		-- For moving around on/near the runway (including airborne).
			-- Source: https://commons.wikimedia.org/wiki/File:Boeing_747_navigation_lights.svg
            typename = "collection",
            lights = {
                [1] = {
                    typename = "Collection",
                    lights = {
                        {
                            typename = "natostrobelight", position = { 17.0, 5.0, 0.000},
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { -17.0, -3.0, 0.000},
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },

						{
                            typename = "Spot", position = { -11.358561, -0.081693, -29.7552 },
                            controller = "VariablePatternStrobe", mode = "1 Flash",
							proto = lamp_prototypes.MPS_1, intensity_max = 750.0, period = 0.333, phase_shift = 0.25,
							direction = {azimuth = math.rad(-90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
                        {
                            typename = "Spot", position = { -11.358136, -0.081694, 29.7551 },
                            controller = "VariablePatternStrobe", mode = "1 Flash",
							proto = lamp_prototypes.MPS_1, intensity_max = 750.0, period = 0.333, phase_shift = 0.25,
							direction = {azimuth = math.rad(90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
						{
                            typename = "Spot", position = { -34.262684, 2.350242, 0 },
                            controller = "VariablePatternStrobe", mode = "1 Flash",
							proto = lamp_prototypes.MPS_1, intensity_max = 750.0, period = 0.333, phase_shift = 0.25,
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
                            typename = "natostrobelight", position = { 17.0, 5.0, 0.000},
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { -17.0, -3.0, 0.000},
                            proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        },
					},
				},
			},
		},
	},
	},
}

add_aircraft(B_747)