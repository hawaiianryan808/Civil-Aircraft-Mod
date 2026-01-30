-- ===================================================================
-- IMPLEMENTATION NOTES (CONVERSION TO B737-700 NG NO WINGLETS)
-- ===================================================================
--[[
CONFIGURATION:		Boeing 737-700 (Standard Wingtips)
MILITARY VERSION:	Boeing C-40 Clipper

1. GEOMETRY UPDATES:
   - Length: 33.63 m (Similar to -300, slightly longer)
   - Wingspan: 34.32 m (112 ft 7 in) - STANDARD NG SPAN
   - Height: 12.55 m (Taller tail than -300)
   - Wing Area: 124.6 m² (Larger NG wing)

2. AERODYNAMIC CHANGES (No Winglets):
   - Induced Drag (Factor B) increased by ~5% vs winglet model.
   - Winglets reduce vortex drag; removing them decreases efficiency.
   - L/D Ratio reduced slightly.

3. PERFORMANCE IMPACT:
   - Cruise Fuel Flow: Increased to 0.70 kg/s (~2500 kg/hr) due to drag penalty.
   - Climb Rate: 17.0 m/s (Better than -300, slightly less than Winglet -700).
   - Range: 5,926 km (Reduced from 6,200 km of winglet version).
   - Service Ceiling: 41,000 ft (12,500 m).

4. ENGINE (CFM56-7B24):
   - Thrust: 24,200 lbf per engine (107.6 kN).
   - Total: ~215,300 N.
--]]

B_737 =  {
      
	Name 			= 'B_737',
	DisplayName		= _('B737-700'),
	date_of_introduction= 1997.12,
	Picture 		= "B-737.png",
	Rate 			= "40",
	Shape			= "B_737", -- Note: Ensure visual model matches (no winglets)
	WorldID			=  WSTYPE_PLACEHOLDER,
	defFuelRatio    = 0.8,
	singleInFlight 	= true,
        
	shape_table_data 	= 
	{
		{
			file  	 	= 'B_737';
			life  	 	= 20; 
			vis   	 	= 3; 
			desrt    	= 'kc-135-oblomok'; 
			fire  	 	= { 300, 2}; 
			username	= 'B_737';
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
	-- MASS & CAPACITY (737-700)
	-- ============================================================
	M_empty		= 37600,	-- [kg] (Slightly lighter than Winglet version ~50kg)
	M_nominal	= 56000,	-- [kg] (Typical ZFW + Fuel)
	M_max		= 70080,	-- [kg] (MTOW HGW)
	M_fuel_max	= 20894,	-- [kg] (Standard Tanks)
	
	-- ============================================================
	-- GEOMETRY & DIMENSIONS
	-- ============================================================
	length 		= 33.63,	-- [m] (110 ft 4 in)
	height 		= 12.55,	-- [m] (41 ft 2 in) - Taller tail
	wing_area	= 124.6,	-- [m^2] (1,341 sq ft) - NG Wing
	wing_span	= 34.32,	-- [m] (112 ft 7 in) - STANDARD SPAN (No Winglets)
	wing_tip_pos = {-4.807, -0.486, 17.092},
	
	-- Gear Positions
	nose_gear_pos 	= 	{ 12.763, -4.165, 0.0}, 		-- Nose gear position (ground under center of the axle)
		
	main_gear_pos 	= 	{-0.374,  -4.17,  3.52},		-- Main gear position (ground under center of the axle)
														-- automatically mirrored
	
	nose_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (arg 2)
	nose_gear_amortizer_reversal_stroke 	 = -0.371,	-- Full Strut Compression (maximum+ weight on wheels)
	nose_gear_amortizer_normal_weight_stroke = -0.078,	-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	nose_gear_wheel_diameter				 =  0.619,	-- Diameter of the nose gear wheel (meters)

	main_gear_amortizer_direct_stroke 		 =  0.0,	-- Full Strut Expansion (no weight on wheels) (args 4 and 6)
	main_gear_amortizer_reversal_stroke 	 = -0.129,	-- Full Strut Compression (maximum+ weight on wheels)
	main_gear_amortizer_normal_weight_stroke = -0.03225,-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	main_gear_wheel_diameter 				 =  1.006,	-- Diameter of the main gear wheels (meters)
	
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
	-- PERFORMANCE PARAMETERS
	-- ============================================================
	H_max 			= 12500,  	-- [m] (41,000 ft Service Ceiling)
	
	-- Speeds (m/s)
	CAS_min 		= 64,  		-- [m/s TAS] Slightly higher stall speed vs Winglet version
	V_opt			= 232,		-- [m/s TAS] Cruise Mach 0.785
	V_take_off		= 73,		-- [m/s TAS] ~142 kts
	V_land			= 70,		-- [m/s TAS] ~136 kts
	V_max_sea_level	= 206,		-- [m/s TAS] Set to max dive speed (Vd = ~400 KCAS) since DCS was magic restricting climb due to powerful engines
	V_max_h			= 246,		-- [m/s TAS] Mach 0.82 MMO
	Mach_max 		= 0.82,
	
	Vy_max 			= 17.0,  	-- [m/s] (Reduced from 18.0 due to drag)
	range 			= 5926,		-- [km] (Standard -700 range without winglets)
	
	-- Limits
	Ny_min			= -1.52,	-- [G]
	Ny_max			= 2.0,		-- [G]
	Ny_max_e		= 2.5,		-- [G]
	bank_angle_max 	= 35,		-- [degrees]
	AOA_take_off 	= math.rad(9.0),
	
	
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
    center_of_mass      = { 1.31, -1.03, 0.0 },				-- [m] CG w.r.t. EDM 3D mesh origin in TsAGI coordinate order

--[[
	MOI and POI (EMPTY configuation) in TsAGI coordinate system.
 
	POI sign check:
	Airliners typically have heavy, podded engines located below the wing (-Y in TsAGI) and
	generally forward of the Center of Gravity (+X), while the empennage/tail (-X)
	structure is high (+Y). The sum of those products should be NEGATIVE.
	
]]
	moment_of_inertia	= {3.83e6, 6.89e6, 6.22e6, -185e3},	-- [kg*m^2] {Roll, Yaw, Pitch, POI}
	
	

	-- ============================================================
	-- ENGINE & FUEL (2x CFM56-7B24)
	-- ============================================================
	-- Thrust (Total 2 Engines):
	-- 2 x 24,200 lbf = 48,400 lbf = ~215,300 N
	thrust_sum_max	= 21950,	-- [kgf] 
	thrust_sum_ab	= 21950,	-- [kgf]
	
	-- Fuel Consumption:
	-- Increased from 0.67 to 0.70 to reflect efficiency loss of no winglets
	average_fuel_consumption = 0.70,  -- [kg/sec] total
	
	has_afteburner		= false,
	has_thrustReverser 	= true,
	engines_count		= 2,
	
	engines_startup_sequence = { 1, 0 }, -- Typical for civilian airliners
	engines_nozzles = 
	{
		[1] = 
		{
			pos 	= {0.53, -2.66, -5.66},
			elevation			= -5.0,	-- 5.0 degree exhaust depression (negative means exhaust points down)
			azimuth             = 1.5,	-- 1.5 degree toe-in (positive means thrust vector points toward longitudinal axis; exhaust points away)
			diameter 			= 1.1,
			exhaust_length_ab	= 3.9624,
			exhaust_length_ab_K	= 0.76,
			smokiness_level     = 0.03,
			engine_number       = 1,
		},
		[2] = 
		{
			pos 	= {0.53, -2.66, 5.66},
			elevation			= -5.0,	-- 5.0 degree exhaust depression (negative means exhaust points down)
			azimuth             = -1.5,	-- 1.5 degree toe-in (negative means thrust vector points toward longitudinal axis; exhaust points away)
			diameter 			= 1.1,
			exhaust_length_ab	= 3.9624,
			exhaust_length_ab_K	= 0.76,
			smokiness_level     = 0.03,
			engine_number       = 2,
		},
	}, 

	-- ============================================================
	-- SYSTEMS & CREW
	-- ============================================================
	has_speedbrake				= true,
	has_differential_stabilizer = false,
	radar_can_see_ground		= false, 	-- Boeing 737-700 sensors cannot detect ground/sea surface units
	flaps_transmission          = "Hydraulic",
    undercarriage_transmission  = "Hydraulic",
	stores_number				= 0,
	tanker_type					= 0,
	flaps_maneuver				= 5/30,	-- Flaps 5 for takeoff; 30 degrees for normal-length field landing (40 degrees possible).
	brakeshute_name				= 0,
	is_tanker					= false,
	
	crew_size	= 2, -- 737NG typically 2 crew
	crew_members = 
	{
		[1] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {14.4, 0.150, -0.408} }, 
		[2] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {14.4, 0.150,  0.408} }, 
	}, 

	RCS						= 45, 	-- [m^2] 
	detection_range_max		= 30,	-- [km] Distance pilots in this airframe can possibly become aware of other airframes
	IR_emission_coeff		= 1.0,	-- Comparable total energy. Cooler exhaust than Su-27, but higher mass flow balances it out.
	IR_emission_coeff_ab	= 0,

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
			-- NG Wing is more efficient than Classic (-300)
			Cy0		= 0.18,		-- Positive lift at zero AoA
			Mzalfa	= 4.6,		-- Pitch stability
			Mzalfadt = 1.2,		-- Pitch damping
			kjx		= 2.2,		-- Roll inertia
			kjz		= 0.0013,	-- Pitch inertia
			Czbe	= -0.020,	-- Directional stability
			
			-- Drag & Lift Coefficients
			cx_gear	= 0.017,	-- Gear drag
			cx_flap	= 0.075,	-- Flaps drag (Double-slotted vs Triple on Classic)
			cy_flap	= 0.95,		-- Flaps lift coefficient
			cx_brk	= 0.02,		-- Speedbrake drag
			
			table_data = {
				-- Aerodynamic Drag Polar Table
				-- M: Mach, Cx0: Zero-lift drag, Cya: Normal force coeff, B/B4: Polar shape
				-- Omxmax: Roll rate, Aldop: Max AoA, Cymax: Max Lift
				-- 		M        Cx0     Cya     B        B4   Omxmax  Aldop    Cymax
				
				-- Low Speed
				[1]  = {0.0,	0.020,	0.095,	0.053,	0.001,	0.45,	15,		1.55},
				[2]  = {0.2,	0.020,	0.095,	0.053,	0.001,	0.50,	15,		1.55},
				[3]  = {0.4,	0.021,	0.095,	0.053,	0.002,	0.50,	14,		1.55},
				[4]  = {0.6,	0.023,	0.090,	0.058,	0.01,	0.55,	13,		1.50},
				
				-- Cruise
				[5]  = {0.7,	0.026,	0.072,	0.063,	0.02,	0.55,	12.5,	1.40},
				[6]  = {0.78,	0.029,	0.070,	0.068,	0.03,	0.55,	12,		1.30},
				
				-- Transonic Drag Rise
				[7]  = {0.82,	0.035,	0.068,	0.084,	0.04,	0.50,	11.5,	1.20},
				[8]  = {0.85,	0.060,  0.066,  0.105,	0.150,  0.8,    11.0,   1.05},
				[9]  = {0.90,	0.090,  0.063,  0.210,	0.300,  0.6,    10.0,   0.80},
				[10] = {1.0,	0.140,  0.060,  0.360,	0.500,  0.4,    8.0,    0.50},
			},
		},
		
		
		engine = {
			typeng 	= 4,
			type 	= "TurboFan",
			
			Nmg		= 59.0,				-- Ground Idle RPM % (60% N2 typical for CFM56-7B)
			Nominal_RPM = 14460.0,		-- 100% speed high pressure turbine (N2)
			Nominal_Fan_RPM = 5175.0,	-- 100% speed fan (N1)
			MinRUD	= 0,
			MaxRUD	= 1,
			MaksRUD	= 1,
			ForsRUD	= 1,
			
			hMaxEng	= 14.0,		-- [km]
			dcx_eng	= 0.0090,
			
			-- FUEL FLOW
			-- Max SFC for CFM56-7B is ~0.67 kg/kgf/h
			cefor	= 0.67,		-- [kg/kgf/h]
			cemax	= 0.67,		-- [kg/kgf/h]
			
			-- Altitude Lapse
			dpdh_m	= 10500,		-- [N/km per engine]
			dpdh_f	= 10500,		-- [N/km per engine]
			
			table_data = 
			{
				-- THRUST TABLE (2x CFM56-7B24)
				-- Static: ~215 kN Total
				-- CORRECTED: CFM56-7B curve
				--      Mach   Newtons   Newtons (Afterburner)
				[1] = {0.0,    215000,     215000},
				[2] = {0.2,    214000,     214000},
				[3] = {0.4,    212000,     212000},
				[4] = {0.6,    210000,     210000},
				[5] = {0.78,   208000,     208000}, -- Cruise Base (Net ~25kN at FL370 - efficient)
				[6] = {0.82,   200000,     200000},
				[7] = {0.9,    160000,     160000},
			},
		},
	},
	
	-- ============================================================
	-- DAMAGE MODEL
	-- ============================================================
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
		[1] = "B_737-OBLOMOK-WING-R",
		[2] = "B_737-OBLOMOK-WING-L",
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
		
		[WOLALIGHT_AUX_LIGHTS] = {
            typename = "Collection",
            lights = {
                [1] = {
                    typename = "collection",
                    lights = {
						{	-- port empennage logo illumination. Source: https://www.pinterest.com/pin/374572893980740008/
                            typename = "Spot",  position = { -5.6, -0.499848, -17.105591 },
							direction = {azimuth = math.rad(117.0), elevation = math.rad(-16.0)}, 
                            proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.8, movable = true,
                        },
						{	-- starboard empennage logo illumination. Source: https://www.pinterest.com/pin/374572893980740008/
                            typename = "Spot",  position = { -5.6, -0.499719, 17.105755 },
							direction = {azimuth = math.rad(-117.0), elevation = math.rad(-16.0)}, 
                            proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.8, movable = true,
                        },
						
						{	-- port aft-facing white tail light. Source: https://www.pinterest.com/pin/374572893980740008/
                            typename = "Spot",  position = { -5.6, -0.499848, -17.105591 },
							direction = {azimuth = math.rad(180.0), elevation = math.rad(0)}, 
                            proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(150.0), angle_min = math.rad(0),
							exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.8, movable = true,
                        },
						{
							typename = "Omni", position = { -5.6, -0.499848, -17.105591 },
							proto = lamp_prototypes.ANO_3_Bl, movable = true,
						},
						{	-- starboard aft-facing white tail light. Source: https://www.pinterest.com/pin/374572893980740008/
                            typename = "Spot",  position = { -5.6, -0.499719, 17.105755 },
							direction = {azimuth = math.rad(180.0), elevation = math.rad(0)}, 
                            proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(150.0), angle_min = math.rad(0.0),
							exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.8, movable = true,
                        },
						{
							typename = "Omni", position = { -5.6, -0.499719, 17.105755 },
							proto = lamp_prototypes.ANO_3_Bl, movable = true,
						},
						
						-- Wing illumination. Source: https://www.pinterest.com/pin/374572893980740008/
						{
                            typename = "Spot",  position = { 10.000, -0.500, -2.00 },
							direction = {azimuth = math.rad(-145.0), elevation = math.rad(1.0)},
                            proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.5, movable = true,
                        },
						{
                            typename = "Spot",  position = { 10.000, -0.500, 2.00 },
							direction = {azimuth = math.rad(145.0), elevation = math.rad(1.0)},
                            proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0),
                            exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.5, movable = true,
                        },
						
						{	-- Anti-collision white strobes
                            typename = "Spot", position = { -5.125769, -0.499848, -17.105591 },
                            controller = "VariablePatternStrobe", mode = "1 Flash",
							proto = lamp_prototypes.MPS_1, intensity_max = 500.0, period = 0.333, phase_shift = 0.25,
							direction = {azimuth = math.rad(-90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
                        {	-- Anti-collision white strobes
                            typename = "Spot", position = { -5.125177, -0.499719, 17.105755 },
                            controller = "VariablePatternStrobe", mode = "1 Flash",
							proto = lamp_prototypes.MPS_1, intensity_max = 500.0, period = 0.333, phase_shift = 0.25,
							direction = {azimuth = math.rad(90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        },
						{	-- Anti-collision white strobes
                            typename = "Spot", position = { -17.0112, -0.971818, 0 },
                            controller = "VariablePatternStrobe", mode = "1 Flash",
							proto = lamp_prototypes.MPS_1, intensity_max = 500.0, period = 0.333, phase_shift = 0.25,
							direction = {azimuth = math.rad(180.0), elevation = math.rad(0)}, angle_max = math.rad(160.0), angle_min = math.rad(0),
                        },
						
                    },
                },
            },
        },
		
        [WOLALIGHT_NAVLIGHTS] = {
            typename = "Collection",
            lights = {
                [1] = {
                    typename = "collection",
                    lights = {
						{typename = "argumentlight",argument = 190}, -- Left Position(red)
						{typename = "argumentlight",argument = 191}, -- Right Position(green)
						{typename = "argumentlight",argument = 192}, -- Tail Position (white)
						
                        {
                            typename = "Spot", position = { -17.0112, 0.971818, 0 },
							direction = {azimuth = math.rad(180.0)}, -- argument = 192,
                            proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(120.0), angle_min = math.rad(0),
                        },
						{
							typename = "Omni", position = { -17.0112, 0.971818, 0 },
							proto = lamp_prototypes.ANO_3_Bl, movable = true,
						},
                        {
                            typename = "Spot", position = { -5.125769, -0.499848, -17.105591 },
							direction = {azimuth = math.rad(-60.0), elevation = math.rad(0)}, -- argument = 190,
                            proto = lamp_prototypes.BANO_7M_red, angle_max = math.rad(120.0), angle_min = math.rad(0),
                        },
                        {
                            typename = "Spot", position = { -5.125177, -0.499719, 17.105755 },
							direction = {azimuth = math.rad(60.0), elevation = math.rad(0)}, -- argument = 191,
                            proto = lamp_prototypes.BANO_7M_green, angle_max = math.rad(120.0), angle_min = math.rad(0),
                        },
						
						-- {	-- port empennage logo illumination. Source: https://www.pinterest.com/pin/374572893980740008/
                            -- typename = "Spot",  position = { -5.6, -0.499848, -17.105591 },
							-- direction = {azimuth = math.rad(117.0), elevation = math.rad(-16.0)}, 
                            -- proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0),
                            -- exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.8, movable = true,
                        -- },
						-- {	-- starboard empennage logo illumination. Source: https://www.pinterest.com/pin/374572893980740008/
                            -- typename = "Spot",  position = { -5.6, -0.499719, 17.105755 },
							-- direction = {azimuth = math.rad(-117.0), elevation = math.rad(-16.0)}, 
                            -- proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0),
                            -- exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.8, movable = true,
                        -- },
						
						-- {	-- port aft-facing white tail light. Source: https://www.pinterest.com/pin/374572893980740008/
                            -- typename = "Spot",  position = { -5.6, -0.499848, -17.105591 },
							-- direction = {azimuth = math.rad(180.0), elevation = math.rad(0)}, 
                            -- proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(150.0), angle_min = math.rad(0),
							-- exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.8, movable = true,
                        -- },
						-- {
							-- typename = "Omni", position = { -5.6, -0.499848, -17.105591 },
							-- proto = lamp_prototypes.ANO_3_Bl, movable = true,
						-- },
						-- {	-- starboard aft-facing white tail light. Source: https://www.pinterest.com/pin/374572893980740008/
                            -- typename = "Spot",  position = { -5.6, -0.499719, 17.105755 },
							-- direction = {azimuth = math.rad(180.0), elevation = math.rad(0)}, 
                            -- proto = lamp_prototypes.ANO_3_Bl, angle_max = math.rad(150.0), angle_min = math.rad(0.0),
							-- exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.8, movable = true,
                        -- },
						-- {
							-- typename = "Omni", position = { -5.6, -0.499719, 17.105755 },
							-- proto = lamp_prototypes.ANO_3_Bl, movable = true,
						-- },
						
						-- -- Wing illumination. Source: https://www.pinterest.com/pin/374572893980740008/
						-- {
                            -- typename = "Spot",  position = { 10.000, -0.500, -2.00 },
							-- direction = {azimuth = math.rad(-145.0), elevation = math.rad(1.0)},
                            -- proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0),
                            -- exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.5, movable = true,
                        -- },
						-- {
                            -- typename = "Spot",  position = { 10.000, -0.500, 2.00 },
							-- direction = {azimuth = math.rad(145.0), elevation = math.rad(1.0)},
                            -- proto = lamp_prototypes.LFS_R_27_130, angle_max = math.rad(22.0), angle_min = math.rad(0),
                            -- exposure = {{0, 0.9, 1.0}}, cool_down_t = 0.5, movable = true,
                        -- },
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
                        {
                            typename = "Spot",  position = { 15.000, -2.900, 0.000 },
							direction = {elevation = math.rad(7.0)}, argument = 51,
                            proto = lamp_prototypes.LFS_P_27_600, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 7.000, -1.600, -2.500 },
							direction = {azimuth = math.rad(-5.0), elevation = math.rad(7.0)},
                            proto = lamp_prototypes.LFS_P_27_600, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 7.000, -1.600, 2.500 },
							direction = {azimuth = math.rad(5.0), elevation = math.rad(7.0)},
                            proto = lamp_prototypes.LFS_P_27_600, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						
						-- Outboard landing lights. Source: https://www.pinterest.com/pin/374572893980740008/
						{
                            typename = "Spot",  position = { -2.500, -1.300, -10.200 },
							direction = {azimuth = math.rad(-8.0), elevation = math.rad(5.0)},
                            proto = lamp_prototypes.LFS_P_27_600, angle_max = math.rad(21.0), angle_min = math.rad(0),
                            cool_down_t = 0.8, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { -2.500, -1.300, 10.200 },
							direction = {azimuth = math.rad(8.0), elevation = math.rad(5.0)},
                            proto = lamp_prototypes.LFS_P_27_600, angle_max = math.rad(21.0), angle_min = math.rad(0),
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
                            typename = "Spot",  position = { 15.000, -2.900, 0.000 }, direction = {elevation = math.rad(4.0)}, argument = 51,
                            proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(33.3), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 7.000, -1.600, -2.500 },
							direction = {azimuth = math.rad(-5.0), elevation = math.rad(4.0)},
                            proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(33.3), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
                        {
                            typename = "Spot",  position = { 7.000, -1.600, 2.500 },
							direction = {azimuth = math.rad(5.0), elevation = math.rad(4.0)},
                            proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(33.3), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						
						-- Runway turnoff lights. These really ought to be animated as part of the wheel steering mechanism, but I don't know how to do that.
						{
                            typename = "Spot",  position = { 7.000, -1.600, -2.500 },
							direction = {azimuth = math.rad(-45.0), elevation = math.rad(10.0)},
                            proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(45.0), angle_min = math.rad(0.0),
                            cool_down_t = 0.5, exposure = {{0, 0.9, 1.0}}, movable = true,
                        },
						{
                            typename = "Spot",  position = { 7.000, -1.600, 2.500 },
							direction = {azimuth = math.rad(45.0), elevation = math.rad(10.0)},
                            proto = lamp_prototypes.LFS_R_27_180, angle_max = math.rad(45.0), angle_min = math.rad(0.0),
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
                        -- {
                            -- typename = "natostrobelight", position = { 2.9, 1.9, 0.000 },
                            -- proto = lamp_prototypes.SMI_2KM, period = 1.50, phase_shift = 0.0,
                        -- },
                        -- {
                            -- typename = "natostrobelight", position = { -2.0, -3.1, 0.000 },
                            -- proto = lamp_prototypes.SMI_2KM, period = 1.50, phase_shift = 0.0,
                        -- },
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
                            typename = "natostrobelight", position = { 2.9, 1.9, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.50, phase_shift = 0.0,
                        },
                        {
                            typename = "natostrobelight", position = { -2.0, -3.1, 0.000 },
                            proto = lamp_prototypes.SMI_2KM, period = 1.50, phase_shift = 0.0,
                        },
						-- {
                            -- typename = "Spot", position = { -5.125769, -0.499848, -17.105591 },
                            -- controller = "VariablePatternStrobe", mode = "1 Flash",
							-- proto = lamp_prototypes.MPS_1, intensity_max = 500.0, period = 0.333, phase_shift = 0.25,
							-- direction = {azimuth = math.rad(-90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        -- },
                        -- {
                            -- typename = "Spot", position = { -5.125177, -0.499719, 17.105755 },
                            -- controller = "VariablePatternStrobe", mode = "1 Flash",
							-- proto = lamp_prototypes.MPS_1, intensity_max = 500.0, period = 0.333, phase_shift = 0.25,
							-- direction = {azimuth = math.rad(90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
                        -- },
						-- {
                            -- typename = "Spot", position = { -17.0112, -0.971818, 0 },
                            -- controller = "VariablePatternStrobe", mode = "1 Flash",
							-- proto = lamp_prototypes.MPS_1, intensity_max = 500.0, period = 0.333, phase_shift = 0.25,
							-- direction = {azimuth = math.rad(180.0), elevation = math.rad(0)}, angle_max = math.rad(160.0), angle_min = math.rad(0),
                        -- },
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
						-- {typename = "argumentlight",argument = 190}, -- Left Position(red)
						-- {typename = "argumentlight",argument = 191}, -- Right Position(green)
						-- {typename = "argumentlight",argument = 192}, -- Tail Position (white)
						-- {
                            -- typename = "natostrobelight", position = { 2.9, 1.9, 0.000 },
                            -- proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        -- },
                        -- {
                            -- typename = "natostrobelight", position = { -2.0, -3.1, 0.000 },
                            -- proto = lamp_prototypes.SMI_2KM, period = 1.5, phase_shift = 0.0,
                        -- },
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
                            typename = "omnilight", position = {15.0, -0.100, 0.5 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.0,
                        },
						{
                            typename = "omnilight", position = {15.0, -0.100, -0.5 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.0,
                        },
						{
                            typename = "omnilight", position = {14.8, 0.400, 0.35 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.0,
                        },
						{
                            typename = "omnilight", position = {14.8, 0.400, -0.35 },
                            color = {203/255, 111/255, 28/255, 0.5}, intensity_max = 1.0,
                        },
                    },
                },
            },
        },
	},
	},
}

add_aircraft(B_737)