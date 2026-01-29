Cessna_210N =  {
--[[
==================================================================================
CESSNA P210N PRESSURIZED CENTURION CONFIGURATION w/ CONTINENTAL TSIO-520-AF ENGINE

This implemenetation is for S/N P21000386 and higher with TSIO-520-AF engines.
This typically corresponds with Cessna P210N made in 1983 or later.

CHANGELOG:
	Implemented advanced piston engine modeling vice simplified
	thrust-table-only modeling.

Useful source: FAA Type Certificate Data Sheet (TCDS) No. 3A21
==================================================================================
]]

	Name										= 'Cessna_210N',
	DisplayName									= _('Cessna P210N'),
	date_of_introduction						= 1978.01,
	Picture										= "Cessna-210N.png",
	Rate										= "40",
	Shape										= "Cessna_210N",
	WorldID										= WSTYPE_PLACEHOLDER, 
	defFuelRatio								= 0.8, -- fuel default in fractions of the full (1.0)
	singleInFlight								= true,
	mapclasskey									= "P0091000029",
	attribute									= {wsType_Air, wsType_Airplane, wsType_Cruiser, WSTYPE_PLACEHOLDER, "Transports",},
	Categories									= {},
	country_of_origin 							= "USA",

	-- ==================================================================================
	-- SHAPE & GEOMETRY
	-- ==================================================================================
	shape_table_data = 
	{
		{
			file		= 'Cessna_210N',
			life		= 20, 
			vis			= 3, 
			desrt		= 'kc-135-oblomok', 
			fire		= { 300, 2}, 
			username	= 'Cessna_210N',
			index		= WSTYPE_PLACEHOLDER,
			classname	= "lLandPlane",
			positioning	= "BYNORMAL",
		},
		{
			name		= "kc-135-oblomok",
			file		= "kc-135-oblomok",
			fire		= { 240, 2},
		},
	},
	
	propellorShapeType							= "3ARG_PROC_BLUR",
	propellorShapeName  						= "CE2_Blade.FBX",

	length										= 8.59,		-- [m] 28 ft 2 in
	height										= 2.87,		-- [m] Adjusted for visual ground contact (Real: 2.95m)
	wing_area									= 16.3,		-- [m] 175 sq ft (approx)
	wing_span									= 11.20,	-- [m] 36 ft 9 in
	
	wing_tip_pos								= {-0.256, 0.82, 5.52},
	
	CanopyGeometry = {
		azimuth		= {-130.0, 130.0},
		elevation	= {-30.0, 70.0}
	},

	-- ==================================================================================
	-- WEIGHTS & FUEL
	-- ==================================================================================
	M_empty										= 1100.4,	-- [kg] 2,426 lbs. empty
	M_max										= 1821.6,	-- [kg] 4016 lbs. MTOW
	M_nominal									= 1420,		-- [kg] Typical mission weight
	M_fuel_max									= 237.2,	-- [kg] 87 US gallons usable out of 90
	average_fuel_consumption					= 0.01295,	-- [kg/sec] 17.1 US gal/hr of 100LL

	-- ==================================================================================
	-- PERFORMANCE LIMITS
	-- ==================================================================================
	H_max										= 7010.4,	-- [m] Service Ceiling 23,000 ft
	Mach_max									= 0.35,		-- MMo (~230 kts)
	V_max_sea_level								= 85.91,	-- [m/s TAS] 167 kts (Max structural cruise Vno is 167 KCAS)
	V_max_h										= 102.89,	-- [m/s TAS] 200 kts (Vne/Max speed at altitude)
	
	V_take_off									= 33.44,	-- [m/s TAS] 65 kts (POH: Vr - rotation speed)
	V_land										= 43.72,	-- [m/s TAS] 80-85 kts (Approach)
	CAS_min										= 29.84,	-- [m/s TAS] 58 kts Stall speed (58 kts landing dirty, 65 clean)
	V_opt										= 98.26,	-- [m/s TAS] 191 kts (Normal cruise)
	Vy_max										= 5,		-- [m/s] (~985 fpm)
	
	range										= 1600,		-- [km] (~860 nmi)
	
	Ny_min										= -1.52,	-- [G] Minimum G-load
	Ny_max										= 2.3,		-- [G] Maximum nominal G-load
	Ny_max_e									= 3.8,		-- [G] Maximum emergency G-load (+3.8G)
	bank_angle_max								= 38,		-- [degrees]
	
	has_afteburner								= false,
	has_speedbrake								= false,
	has_differential_stabilizer					= false,
	radar_can_see_ground						= false,
	is_tanker									= false,
	tanker_type									= 0,

	-- ==================================================================================
	-- LANDING GEAR
	-- ==================================================================================
	nose_gear_pos								= {1.2595, -1.2549, 0},		-- Nose gear position (ground under center of the axle)
	nose_gear_amortizer_direct_stroke			=  0.0,						-- Full Strut Expansion (no weight on wheels) (arg 2)
	nose_gear_amortizer_reversal_stroke			= -0.0502,					-- Full Strut Compression (maximum+ weight on wheels)
	nose_gear_amortizer_normal_weight_stroke	= -0.015,					-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	nose_gear_wheel_diameter					=  0.355,					-- Diameter of the nose gear wheel (meters)
	
	main_gear_pos								= {-0.536, -1.1385, 1.402},	-- Main gear position (ground under center of the axle)
	main_gear_amortizer_direct_stroke			=  0.0,						-- Full Strut Expansion (no weight on wheels) (args 4 and 6)
	main_gear_amortizer_reversal_stroke			= -0.02,					-- Full Strut Compression (maximum+ weight on wheels)
	main_gear_amortizer_normal_weight_stroke	= -0.01,					-- Strut Weight Compression (normal compression with weight on wheels; number is amount of "chrome showing")
	main_gear_wheel_diameter					=  1.349,					-- Diameter of the main gear wheels (meters)
	
	
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
	tand_gear_max								= math.tan(math.rad(35)),
	
	
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
	-- DCS Origin (0,0) = Station 37" (Pilot)
	-- Target CG: Station 39-40" (Stable, slightly nose heavy)
	-- DCS Coordinates: {x (Longitudinal), y (Vertical), z (Lateral)}
    -- x: -0.06 (Slightly aft of datum)
    -- y: -0.20 (Below the wing at pilot's hips or navel)
    -- z:  0.00 (Centered laterally)
    center_of_mass      = {-0.06, -0.20, 0},				-- [m] CG w.r.t. EDM 3D mesh origin in TsAGI coordinate order

--[[
	MOI and POI (EMPTY configuation) in TsAGI coordinate system.
 
	POI sign check:
	Airliners typically have heavy, podded engines located below the wing (-Y in TsAGI) and
	generally forward of the Center of Gravity (+X), while the empennage/tail (-X)
	structure is high (+Y). The sum of those products should be NEGATIVE.
	
]]
	-- moment_of_inertia							= {2500, 3500, 4100},
	moment_of_inertia	= {8500, 12900, 11600, -150},	-- [kg*m^2] {Roll, Yaw, Pitch, POI}
	

	-- ==================================================================================
	-- AERODYNAMICS (Simple Flight Model)
	-- ==================================================================================
	AOA_take_off								= math.rad(10),	-- ~10 deg
	flaps_maneuver								= 10/30,		-- Takeoff flaps: Flaps 10; landing = max @ 30 degrees
	
	SFM_Data = {
		aerodynamics = {
			-- Based on NASA TN D-7197 (Wind Tunnel Test of Light High-Wing Airplane - Cessna 210)
			-- https://ntrs.nasa.gov/api/citations/19730016341/downloads/19730016341.pdf
			
			-- Lift & Stability
			Cy0			= 0.05,		-- Lift coefficient at zero AoA (High camber wing)
			Mzalfa		= 4.4,		-- High pitch stability (Heavy nose / long tail)
			Mzalfadt	= 0.8,		-- Pitch damping
			kjx			= 1.8,		-- Roll inertia
			kjz			= 0.0018,	-- Pitch inertia
			Czbe		= -0.045,	-- Directional stability
			
			-- Drag Coefficients
			cx_gear		= 0.045,	-- Gear drag
			cx_flap		= 0.150,	-- Flap drag
			cy_flap		= 0.600, 	-- Flap lift
			cx_brk		= 0.060,	-- No speedbrakes
		
			table_data = {
				-- REVISED: Based on NASA TN D-7197 (Wind Tunnel Test of Light High-Wing Airplane - Cessna 210)
				-- https://ntrs.nasa.gov/api/citations/19730016341/downloads/19730016341.pdf
				
				-- M     Cx0     Cya      B       B4    Omxmax   Aldop   Cymax
				{0.0,   0.029,  0.095,  0.038,  0.001,  0.40,   16.0,   1.50}, -- Static
				{0.05,  0.029,  0.095,  0.038,  0.001,  0.40,   16.0,   1.50}, -- Taxi/Roll
				{0.10,  0.029,  0.095,  0.038,  0.001,  0.40,   16.0,   1.50}, -- Climb
				-- Cruise Regime
				{0.15,  0.028,  0.096,  0.035,  0.002,  0.35,   15.5,   1.48}, 
				{0.20,  0.028,  0.096,  0.035,  0.002,  0.32,   15.0,   1.45},
			},
		},
		
		-- ==================================================================================
		-- ENGINE (Continental TSIO-520-AF | 310 HP Turbocharged)
		-- ==================================================================================
		engine = {
			type					= "Piston",
			typeng					= 2,
			
			-- Continental TSIO-520-AF Specs
			Nominal_RPM				= 2700,		-- Engine RPM
			Nmg						= 25.0,		-- Idle RPM % (~600-700 RPM)
			Displ					= 8.52,		-- [L] 520 cu in (https://www.aopa.org/go-fly/aircraft-and-ownership/aircraft-fact-sheets/cessna-210)
			Stroke					= 0.102, 	-- [m] Cylinder stroke length - https://en.wikipedia.org/wiki/Continental_O-470
			V_pist_0				= 6,		-- [#] Number of cylinders/pistons (whole number)
			cylinder_firing_order	= {1, 4, 5, 2, 3, 6},	-- http://oceanair.ca/wp-content/uploads/2015/01/O470R_engine_specs.pdf
			-- name					= "LYCOMING",  -- used to determine sounds?
			
			-- McCauley D3A34C402/90DFA-10 3-Blade Constant Speed Prop
			prop_direction			= 1,		-- +1 for CCW when viewed from front, -1 for CW when viewed from front
			D_prop					= 2.032,	-- [m] 80 inch prop
			MOI_prop				= 5.7,		-- [kg*m^2] Propeller moment of inertia
			Init_Mom				= 200,		-- [N*m] Starting torque
			prop_blades_count		= 3,		-- [#] Number of blades on each prop
			k_gearbox				= 1.0,		-- Engine/propeller gearbox ratio (inverse of reduction ratio; never less than 1.0 in DCS)
			prop_pitch_min			= 12.4,		-- [Deg]
			prop_pitch_max			= 28.5,
			prop_pitch_feather		= 0,		-- If prop_pitch_feather < prop_pitch_max then no feathering available
			
			-- The prop axis is along points (2.495246, -0.105623) and (2.1088955, -0.0770895)
			prop_locations			= { { 2.191, -0.083153, 0 }, {0.0, 0.0, math.rad(-3.0)} },
			
			-- Turbocharged Altitude Performance
			hMaxEng					= 5.5,		-- [km] Critical altitude (~18,000 ft) where wastegate closes fully
			-- Thrust/Power Lapse
			-- Note: The type = "Piston" engine model in DCS uses the hMaxEng,
			-- MAX_Manifold_P, and k_boost parameters to calculate performance
			-- at altitude. Setting dpdh_m to 0 prevents the "simple" linear
			-- decay from overriding the complex piston physics.
			dpdh_m					= 0,		-- [N/km] set to zero to rely entirely on piston engine aero-thermodynamic modeling
			dpdh_f					= 0,
			
			-- FUEL CONSUMPTION
			cemax					= 0.02268,	-- [kg/s] FSC per engine (180 lbs/hr)
			cefor					= 0.02268,	-- [kg/s] FSC per engine (afterburner)
			dcx_eng					= 0.015,	-- [coeff] Cowl flap/engine cooling drag
			
			-- Manifold Pressure (TSIO-520-AF Limits)
			MAX_Manifold_P_1		= 113444,	-- [Pa] Manifold Pressure for Max Continuous (33.5 inHg)
			MAX_Manifold_P_2		= 115000,	-- [Pa] Manifold pressure for dry takeoff (34 inHg approx)
			MAX_Manifold_P_3		= 123600,	-- [Pa] Manifold pressure for wet takeoff or war emergency power (36.5 inHg)
			
			N_indic_0				= 231000,	-- [W] Indicated power (310 HP = 231 kW)
			
			N_fr_0					= 0.045,	-- Static Friction Coefficient (The "Stiction" Factor - 4.5% HP lost at any RPM)
			N_fr_1					= 0.015,	-- Dynamic Friction Coefficient (The "Viscosity" Factor - additional 1.5% HP lost at 100% RPM)
											--[[	Based on the analysis of the engine definition files for the P-51D,
													Spitfire, and B-17G, here is the technical explanation of N_fr_0 and N_fr_1.
													
													The "N_fr" Parameters: Engine Friction Coefficients

													In the DCS Standard Flight Model (SFM) Piston Engine (typeng = 2), the
													variables N_fr_0 and N_fr_1 parameterize the Mechanical Friction Power
													Loss of the engine.

													They represent the power consumed by the engine itself to turn its own
													internal components (pistons, crankshaft, valvetrain, accessories) before
													any power is delivered to the propeller shaft.
													
													
													1. The Formula (Conceptual)

													DCS calculates the Shaft Horsepower (SHP) available to the propeller
													using a formula similar to this:
													
																	N_shaft​ = N_indicated​ − N_friction​

													Where Friction Power (N_friction​) is calculated using N_indic_0
													(Reference Power) as a scalar:
													
															N_friction ​= N_indic_0​ * ( N_fr_0​ + (N_fr_1​ * RPM​%) )

														N_indic_0:	The engine's reference maximum Indicated Power
																	(in Watts). For the P-51D, this is
																	1,023,040 W (~1,370 HP).

														RPM%: 		Current RPM expressed as a proportion (0.0 to 1.0).
														
													
													2. Parameter Definitions
													
													N_fr_0:	Static Friction Coefficient (The "Stiction" Factor)

														What it represents:	The constant baseline friction present regardless
																			of RPM. This includes seal drag, oil viscosity
																			resistance at low speed, and the basic effort
																			required to turn the assembly.

														Effect in Simulation:

															Startup:	Determines how much torque the starter motor needs
																		to overcome to begin turning the engine. If this is
																		too high, the prop will twitch but not spin.

															Idle: 		Sets the "floor" for fuel consumption/manifold pressure
																		required to keep the engine running.

														Typical Values:

															0.072:	Standard for WWII Warbirds (P-51, Spitfire, B-17).

															0.045:	Typical for modern, lighter General Aviation engines
																	(like the Cessna 210).

													N_fr_1:	Dynamic Friction Coefficient (The "Viscosity" Factor)

														What it represents:	The linear increase in friction as RPM rises.
																			As the engine spins faster, pumping losses,
																			oil shear, and piston ring friction increase.

														Effect in Simulation:

															RPM Decay:	Determines how quickly the RPM drops when you chop
																		the throttle. High N_fr_1 makes the engine decelerate
																		aggressively (high compression braking).

															Top Speed Efficiency: At max RPM, this subtracts from your total power.

														Typical Values:

															0.02:	Standard for WWII Warbirds.

															0.01:	Typical for modern GA engines.
														
													
													3. Behind the Scenes: How DCS Uses It

													The "Idle" Equilibrium: When you pull the throttle to idle, the engine
													produces just enough Indicated Power (from combustion) to match the
													Friction Power (N_fr_0 + N_fr_1​).

														If N_fr is too high:
														The engine will die at idle because friction > combustion power.

														If N_fr is too low:
														The engine will "hang" at high RPM and take forever to spin down.

													Windmilling & Propeller Drag: 
														If the engine fails or is shut down in flight, these coefficients
														determine the resistance the airstream fights against to windmill
														the prop.

														High friction values =	Prop stops spinning sooner / creates
																				more drag if not feathered.

													Mechanical Efficiency Calculation:
														By summing these values, you can determine the modeled mechanical
														efficiency at 100% RPM.

														Warbird Example: 0.072 + 0.02 = 0.092 (9.2% Friction Loss).

														Result:	The engine is ~91% efficient mechanically, which is
																realistic for high-performance piston engines.


													Summary for Modders

														Increase N_fr_0 if:
															Your engine takes too long to stop after shutdown or
															idles too fast.

														Decrease N_fr_0 if:
															Your starter motor can't turn the prop.

														Increase N_fr_1 if:
															The RPM doesn't drop fast enough when you cut the throttle
															in the air.
											]]
			
			-- Engine Power/Torque multipliers
			Nu_0					= 1.25,	-- "Static Displacement" Factor (see [3] below)
			Nu_1					= 1.25,	-- "Turbo Boost" Factor (see [3] below)
			Nu_2				= 0.0015,	-- "High Speed Loss" Factor (see [3] below)
										--[[	Based on the comprehensive reverse-engineering and validation against
												official DCS modules (P-47, B-17, FW-190), here is the technical
												documentation for the Nu parameters within the DCS Standard Flight
												Model (SFM) Piston Engine (typeng = 2).
												
												
												1. Executive Summary

												In the DCS Standard Flight Model (SFM) for Piston Engines (typeng = 2),
												the Nu coefficients are Power/Torque Multipliers. They do not define
												propeller drag or efficiency in the traditional aerodynamic sense.

												They function as a transfer function that converts the raw
												"Thrust Potential" defined in the thrust table_data into the actual
												"Effective Thrust" applied to the airframe, based on RPM and Speed.
												
												
												2. The Equation (Conceptual)

												The physics engine calculates the final thrust vector roughly using
												this logic:
												
												Thrust_final​ = ThrTablVal[M] * ( Nu_0 ​+ (Nu_ 1​ * RPM%​) − (Nu_2 * M^2) )

													M: Current airspeed (in Mach).
													
													ThrTablVal: The raw force (Newtons) from your table_data at M.

													RPM%: Engine speed proportion (0.0 to 1.0).
										
										
												3. Parameter Definitions
												
												Nu_0: The "Static Displacement" Factor

													What it represents: The engine's Base Volumetric Efficiency or
																		Static Torque.

													Physical Analogy: 	Think of this as the size of the cylinders
																		(displacement). A big 520 cu in engine has
																		high "grunt" even at low RPM.

													Behavior:

														Higher Value (e.g., 2.0): Provides massive static pull.
														Essential for getting high-drag airframes moving on the runway.

														Lower Value (e.g., 1.2): Standard for low-drag airframes (Warbirds).

													Symptom of Tuning: 	If your plane is stuck at 16 knots on the runway
																		despite full throttle, then increase Nu_0.

												Nu_1: The "Turbo Boost" Factor (Linear)

													What it represents:	The Slope of the Power Curve. It defines how
																		much extra torque is generated as RPM increases.

													Physical Analogy: 	In a Turbocharged engine, this represents the
																		Boost Curve. As RPM rises, the turbo spins faster,
																		manifold pressure increases, and torque spikes
																		non-linearly.

													Behavior:

														High Value (e.g., 2.5): Simulates a high-boost turbocharger.
														Power output skyrockets at high RPM (2700), allowing the plane
														to push through high drag to reach cruise speeds (170 kts).

														Low Value (e.g., 0.75): Simulates a naturally aspirated or
														"choked" engine. Power flattens out early.

													Symptom of Tuning: 	If your plane accelerates well initially but hits
																		a "wall" at 97 knots (cruise speed too low),
																		then increase Nu_1.

												Nu_2: The "High Speed Loss" Factor (Quadratic)

													What it represents: Efficiency Loss due to compressibility or backpressure.

													Physical Analogy: 	Propeller tips hitting supersonic speeds (Mach 0.9+)
																		or intake choking.

													Behavior:

														0.0: 	No penalty. Ideal for General Aviation aircraft where prop tips
																stay subsonic.

														>0.002:	Adds a "Drag Wall" at high speeds. Used for WW2 fighters to
																prevent them from exceeding V_ne in a dive.

													Symptom of Tuning:	If your plane is overspeeding at altitude
																		(e.g., doing 300 kts when it should do 170),
																		then increase Nu_2.
												
												
												4. Visualizing the Curve

												To better understand Nu_1, imagine a graph of Thrust vs. RPM:

													Low Nu_1 (0.75):	The line is shallow. At 100% RPM, you only get ~75%
																		of the table's potential thrust.

													High Nu_1 (2.5):	The line is steep. At 100% RPM, you get 250% of the
																		table's potential thrust. (This is how we simulate
																		the massive power jump of a TSIO-520 turbo system).
												
												
												5. Summary Table for Modders
												
												  Parameter	   Function						Tuning Goal
												  ---------	   ---------					-----------
													Nu_0	Static Multiplier	Fixes "Stuck on Runway" / Taxi issues.
													Nu_1	RPM Multiplier		Fixes "Low Top Speed" / Simulates Turbo Boost.
													Nu_2	Drag Penalty		Fixes "Overspeeding" / Simulates Prop Drag.
										
										
												6. Why This Matters for the Cessna P210N

												Because the DCS SFM calculates airframe drag conservatively (often higher than
												reality for light aircraft), we use Nu_1 = 2.5 to force the engine to output
												the raw horsepower needed to overcome that drag and match the real-world
												cruise speed of 168 KTAS.
										]]
			
			-- Thermodynamics
			k_adiab_1			= 0.0275,	-- Adiabatic efficiency (low blower)
			k_adiab_2			= 0.0275,	-- Adiabatic efficiency (high blower)
										--[[	Real-World Equivalent: Compressor Adiabatic Efficiency (η_c​).

												Definition: Defines how much heat is added to the air during compression.
												_1 and _2 likely refer to the different supercharger gears
												(Low Blower / High Blower).

												Reality Check: Compressing air heats it up. Hotter air is less dense
												(less power) and causes detonation. A value closer to 1.0 implies a
												very efficient blower that adds minimal excess heat.]]
			
			k_after_cool			= 0.0,	-- [proportion] Intercooler/aftercooler effectiveness or efficiency 
											-- 		(% heat removed from air before entering cylinders)
										--[[	Reality Check: Crucial for high-altitude performance. If this value is low,
												the engine will overheat or detonate at high power settings (common in
												early war aircraft like the Spitfire V vs. the intercooled Spitfire IX).]]
											
			k_boost					= 3.0,	-- Supercharger boost factor/Boost scaling
										--[[	Real-World Equivalent: Charge density scalar.

												Definition: Likely a coefficient linking Manifold Pressure to actual
												air mass entering the cylinder (Volumetric Efficiency scalar).
												That is, how many times ambient pressure is the turbocharger
												capable of providing to the piston cylinders.]]
											
			k_cfug					= 0.0,	-- [coeff] Supercharger Centrifugal Compressor Pressure Rise
										--[[	Real-World Equivalent: Centrifugal Compressor Pressure Rise
												(proportional to RPM^2).

												Definition: Defines how much pressure the supercharger impeller
												generates based on its rotational speed.

												Reality Check: Centrifugal superchargers (like in the P-51 or F4U)
												generate boost exponentially with RPM. A higher k_cfug means the
												supercharger builds boost much faster as RPM climbs.
												
												Turbocharger: Unlike the centrifugal superchargers in WWII planes
												(where boost rises with RPM^2), the TSIO-520 uses a wastegate turbo.
												Set this to 0 or very low, and rely on MAX_Manifold_P limits to
												simulate the wastegate holding pressure constant.
											]]
											
			k_Eps					= 7.5,	-- [ratio] Cylinder compression ratio (volume ratio from bottom dead center to top dead center)
										--[[	Real-World Equivalent: Compression Ratio (ϵ).

												Definition: The ratio of the cylinder volume at bottom dead center to top
												dead center (e.g., 6.0:1 or 8.5:1).

												Reality Check: Higher k_Eps yields higher thermal efficiency (more power)
												but increases the risk of detonation (knocking), requiring higher octane fuel.
												This parameter directly feeds the thermal efficiency equation:
											
															η = 1 − ( 1 / ϵ^(γ−1) )​
											]]

			k_oil					= 3e-5,	-- Oil Drag/Viscocity factor
										--[[	Real-World Equivalent: Oil Shearing resistance.

												Definition: Likely models the parasitic loss caused by the oil pump
												and the viscosity of the oil, which changes with temperature.
											]]
			
			k_piston				= 3000,	-- Indicated Mean Effective Pressure (IMEP) scaler
										--[[	Real-World Equivalent: Mean Piston Speed or Indicated Mean Effective
												Pressure (IMEP) scaler.

												Definition: This likely scales the efficiency of the combustion cycle
												relative to the physical speed of the pistons.

												Reality Check: As piston speed increases, volumetric efficiency usually drops
												(less time to fill the cylinder). This parameter helps define the
												"torque peak" of the engine.
											]]
			
			k_reg					= 1.5e-5,	-- Regulator Gain/Response
										--[[	The "k_reg" Parameter: Manifold Pressure Regulator Gain

												In the DCS Standard Flight Model (SFM) Piston Engine (typeng = 2),
												k_reg (Coefficient of Regulation) defines the sensitivity and speed of the
												automatic boost regulator (wastegate controller) or the constant-speed
												propeller governor.

												It essentially sets the "Gain" (K) in the feedback loop that attempts to
												keep the Manifold Pressure (MP) or RPM constant as altitude and airspeed
												change.
												
												1. How It Works Behind the Scenes

												The engine simulation runs a continuous control loop (likely at 10 Hz or
												similar) to manage the turbocharger wastegate or throttle butterfly
												position.

												The Control Logic:

													Calculate Error:  The system compares the Target Pressure (set by the
																	  throttle lever position and MAX_Manifold_P) against
																	  the Current Pressure (what the engine is actually
																	  producing).
													
																	Error = Target_MP ​ − Current_MP​

													Apply Correction: The system calculates how much to open or close
																	  the wastegate/throttle to fix this error.
																	  
																	Correction Rate = Error * k_reg

													Update State:	  The actuator moves at this calculated rate.

													If k_reg is High: The actuator moves fast to correct small errors.

													If k_reg is Low:  The actuator moves slowly, taking its time to
																	  correct errors.
												
												2. Tuning Symptoms

												You can determine if your k_reg is wrong by observing the Manifold Pressure
												gauge during two specific maneuvers: Level Flight at Altitude and Rapid
												Throttle Changes.
												
												Scenario A: The Value is Too High (Over-Sensitive)

													Symptom: "Hunting" / Oscillation.

													Observation: You are flying level at 15,000 ft. You see the Manifold Pressure
													needle (and RPM) wobbling back and forth (e.g., 35" → 37" → 34" → 36").
													The engine sounds like it is "surging" (revving up and down rhythmically).

													Why: The regulator sees a 1" drop, panics, and slams the wastegate shut.
													The pressure spikes to +2". The regulator sees the spike, panics, and slams
													the wastegate open. It never settles.

													Fix: Reduce k_reg.

												Scenario B: The Value is Too Low (Lazy)

													Symptom: "Droop" / Lag.

													Observation: You slam the throttle forward for takeoff. The Manifold Pressure
													rises sluggishly and takes 5–6 seconds to reach the redline. Or, as you climb,
													the Manifold Pressure slowly drifts downward, and the turbo can't seem to
													"keep up" with the thinning air.

													Why: The regulator sees the error, but the correction signal is so weak that
													the wastegate closes too slowly to catch up with the changing conditions.

													Fix: Increase k_reg.

												3. Empirical Tuning Procedure

												To tune this perfectly for a mod like the Cessna P210N, follow this test flight
												procedure:

													The "Slam" Test (Response Time):

														Setup: Fly at Sea Level, low power (20" MP).

														Action: Rapidly advance throttle to full.

														Ideal: The needle should shoot up and stop exactly at 36.5" instantly.

														Too High: The needle shoots past 36.5" to 40" (Overshoot), then drops back.

														Too Low: The needle crawls up and takes seconds to stabilize.

													The "Cruise" Test (Stability):

														Setup: Fly at Critical Altitude (e.g., 20,000 ft).

														Action: Set cruise power and wait.

														Ideal: The needle is rock solid.

														Too High: The needle wanders or oscillates (The "Hunting" you experienced).
												
												
												Summary:
												
														Parameter		Definition			Tuning Direction
														---------		----------			----------------
														
														k_reg			Regulator Gain		Hunting?  Decrease value.

																							Laggy?    Increase value.
											]]
											
			k_vel					= 5e-3,	-- Ram Air Recovery factor
										--[[	Real-World Equivalent: Intake Ram Recovery Ratio.

												Definition: How effectively the aircraft speed (V) increases the
												air pressure at the supercharger intake (Ram Effect).

												Reality Check: At 400 mph, a well-designed intake (like the P-51's
												underbelly scoop) provides significant "free boost" simply from the
												air rushing in. A high k_vel models a highly efficient scoop.
											]]
			
			P_oil					= 413685,	-- [Pa] Oil pressure (60 psi) 
												-- http://www.aeroelectric.com/Reference_Docs/Cessna/cessna-poh/Cessna_210_T210N-1982-POH_scanned.pdf
			
			-- Startup
			Init_Mom				= 200,		-- [N*m] Starting torque
			Startup_Prework			= 15,
			Startup_Ignition_Time	= 4,
			Shutdown_Duration		= 7,
			Startup_RPMs			= { {0, 0}, {1, 200}, {2, 600} },
			
			MinRUD					= 0,
			MaxRUD					= 1,
			MaksRUD					= 1,
			ForsRUD					= 1,
			
			-- THRUST TABLE CORRECTION
			-- 310 HP (231 kW) output.
			-- Formula: Thrust = (Power * Efficiency) / Velocity
			table_data = {
				-- REVISED Thrust Table (Base Newtons before Multiplier)
				-- We need lower static thrust but sustained high-speed thrust.
			--	  M      Pmax (N)
				{0.0,    4950},     -- Static (With Nu=1.2, Total = ~1300 lbs / 5900 N) -> Perfect for P210
				{0.1,    4400},     -- Climb (Reduced to prevent zoom)
				{0.15,   3950},     -- Normal Climb
				{0.2,    3500},     -- Cruise Climb
				{0.25,   2900},     -- Fast Cruise
				{0.3,    2800},     -- Max Cruise
				{0.35,   2000},     -- MMO
			},
		},
	},
	
	-- Update top level thrust to match static
	thrust_sum_max								= 495,	-- [kgf]
	thrust_sum_ab								= 495,	-- [kgf]
	
	engines_count								= 1,
	engines_nozzles = {
		[1] = {														-- Port side exhaust (not in EDM)
			pos									= {1.40, -0.715, -0.395},
			elevation							= math.rad(-10),	-- Exhausts down
			diameter							= 0.08,				-- [m] 3.0 inches exhaust pipe diameter
			exhaust_length_ab					= 0.2,
			exhaust_length_ab_K					= 0.2,
			smokiness_level						= 0.04,
			engine_number						= 1,
		},
		[2] = {														-- Starboard side exhaust (not in EDM)
			pos									= {1.40, -0.715, 0.395},
			elevation							= math.rad(-10),	-- Exhausts down
			diameter							= 0.08,				-- [m] 3.0 inches exhaust pipe diameter
			exhaust_length_ab					= 0.2,
			exhaust_length_ab_K					= 0.2,
			smokiness_level						= 0.04,
			engine_number						= 1,
		},
	},

	-- ==================================================================================
	-- SYSTEMS & SENSORS
	-- ==================================================================================
	RCS											= 5,
	detection_range_max							= 15,		-- [km] Distance pilots in this airframe can possibly become aware of other airframes
	IR_emission_coeff							= 0.05,		-- Negligible signature compared to jet exhaust; limited to hot metal (manifold) and small CO2 volume.
	IR_emission_coeff_ab						= 0,
	
	Failures = {
		{ id = 'asc',			label = _('ASC'),			enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'autopilot',		label = _('AUTOPILOT'),		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'hydro',			label = _('HYDRO'),			enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'l_engine',		label = _('L-ENGINE'),		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'r_engine',		label = _('R-ENGINE'),		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
	},
	
	HumanRadio = {
		frequency		= 127.5,
		editable		= true,
		minFrequency	= 118.000,
		maxFrequency	= 137.000,
		modulation		= MODULATION_AM
	},

	Pylons = {},
	
	Tasks = {
		aircraft_task(Transport),
	},  
	DefaultTask = aircraft_task(Nothing),
	stores_number = 0,
	
	crew_size									= 1,
	crew_members =  {
		[1] = {
			ejection_seat_name 	= 0,
			drop_canopy_name 	= 0,
			pos 				= {0, 0, -0.256},
			pilot_body_arg 		= 50,
			pilot_name			= "CE2_Pilot_02",
			drop_parachute_name = "CE2_Pilot_01_Parachute",
			role 				= "pilot",
			role_display_name   = _("Pilot"),	
		},
	},
	
	brakeshute_name								= 0,
	
	fires_pos = {
		[1] =	{-0.138,	-0.79,	0},
		[2] =	{-0.138,	-0.79,	5.741},
		[3] =	{-0.138,	-0.79,	-5.741},
		[4] =	{-0.82,		0.265,	2.774},
		[5] =	{-0.82,		0.265,	-2.774},
		[6] =	{-0.82,		0.255,	4.274},
		[7] =	{-0.82,		0.255,	-4.274},
		[8] =	{-0.347,	-1.875,	8.138},
		[9] =	{-0.347,	-1.875,	-8.138},
		[10] =	{-5.024,	-1.353,	13.986},
		[11] =	{-5.024,	-1.353,	-13.986},
	},
	
	doors_movement = 2,		-- Enable custom doors mechanimations
	mechanimations = {
		Door0 = {
			{ Transition = { "Close", "Open" },  Sequence = { { C = { { "Arg", 38, "to", 0.9, "in", 5.5 },
																	  { "Arg", 325, "from", -1.0, "to", -0.001, "in", 1.5},			
																	}, }, }, Flags = { "Reversible" }, },
			{ Transition = { "Open", "Close" },  Sequence = { { C = { { "Arg", 38, "to", 0.0, "in", 5.0 }, }, }, }, Flags = { "Reversible", "StepsBackwards" }, },
			{ Transition = { "Any", "Bailout" }, Sequence = { { C = { { "JettisonCanopy", 0 }, }, }, }, },
		},
	},

	-- ==================================================================================
	-- DAMAGE MODEL
	-- ==================================================================================
	Damage = {
		[0]  = {critical_damage = 5,	args = {146}},
		[1]  = {critical_damage = 3,	args = {296}},
		[2]  = {critical_damage = 3,	args = {297}},
		[3]  = {critical_damage = 8,	args = {65}},
		[4]  = {critical_damage = 2,	args = {298}},
		[5]  = {critical_damage = 2,	args = {301}},
		[7]  = {critical_damage = 2,	args = {249}},
		[8]  = {critical_damage = 3,	args = {265}},
		[9]  = {critical_damage = 3,	args = {154}},
		[10] = {critical_damage = 3,	args = {153}},
		[11] = {critical_damage = 1,	args = {167}},
		[12] = {critical_damage = 1,	args = {161}},
		[13] = {critical_damage = 2,	args = {169}},
		[14] = {critical_damage = 2,	args = {163}},
		[15] = {critical_damage = 2,	args = {267}},
		[16] = {critical_damage = 2,	args = {266}},
		[17] = {critical_damage = 2,	args = {168}},
		[18] = {critical_damage = 2,	args = {162}},
		[20] = {critical_damage = 2,	args = {183}},
		[23] = {critical_damage = 5,	args = {223}},
		[24] = {critical_damage = 5,	args = {213}},
		[25] = {critical_damage = 2,	args = {226}},
		[26] = {critical_damage = 2,	args = {216}},
		[29] = {critical_damage = 5,	args = {224}, deps_cells = {23, 25}},
		[30] = {critical_damage = 5,	args = {214}, deps_cells = {24, 26}},
		[35] = {critical_damage = 6,	args = {225}, deps_cells = {23, 29, 25, 37}},
		[36] = {critical_damage = 6,	args = {215}, deps_cells = {24, 30, 26, 38}}, 
		[37] = {critical_damage = 2,	args = {228}},
		[38] = {critical_damage = 2,	args = {218}},
		[39] = {critical_damage = 2,	args = {244}, deps_cells = {53}}, 
		[40] = {critical_damage = 2,	args = {241}, deps_cells = {54}}, 
		[43] = {critical_damage = 2,	args = {243}, deps_cells = {39, 53}},
		[44] = {critical_damage = 2,	args = {242}, deps_cells = {40, 54}}, 
		[51] = {critical_damage = 2,	args = {240}}, 
		[52] = {critical_damage = 2,	args = {238}},
		[53] = {critical_damage = 2,	args = {248}},
		[54] = {critical_damage = 2,	args = {247}},
		[56] = {critical_damage = 2,	args = {158}},
		[57] = {critical_damage = 2,	args = {157}},
		[59] = {critical_damage = 3,	args = {148}},
		[61] = {critical_damage = 2,	args = {147}},
		[82] = {critical_damage = 2,	args = {152}},
	},
	
	DamageParts = 
	{  
		[1] = "Cessna_210N-oblomok-wing-R",
		[2] = "Cessna_210N-oblomok-wing-l",
	},

	-- ==================================================================================
	-- LIGHTS
	-- ==================================================================================
	
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
	lights_data = {
		typename = "collection",
		lights = {
			
			[WOLALIGHT_NAVLIGHTS] = {
				-- 	The argument lights are permanently bright which is a 3D model thing and has to be fixed there.
				-- 	The lights defined below will bounce off nearby objects, but you cannot observe them directly
				-- 	so they don't become balls of light at a distance -- only the 3D model can do that.
				typename = "Collection",
				lights = {
				{	
						-- The next 3 don't do anything in the Cessna EDM for some reason.
						{typename = "argumentlight", argument = 190}, -- Left Position(red)
						{typename = "argumentlight", argument = 191}, -- Right Position(green)
						{typename = "argumentlight", argument = 192}, -- Tail Position (white)
						
						-- {typename = "argumentlight",argument = 408}, -- Brightens all nav lights a bit (Cessna only)
						
						{
							typename = "natostrobelight", position = { -5.341401, 1.789537, 0.00 },
							proto = lamp_prototypes.MSL_3_2, period = 1.5, 
						},
						{
							typename = "Spot", position = { -6.0, 1.70, 0 },
							direction = {azimuth = math.rad(180.0)}, -- argument = 192,
							proto = lamp_prototypes.HS_2A, angle_max = math.rad(140.0), angle_min = math.rad(0),
						},
						{
							typename = "Omni", position = { -6.0, 1.70, 0 },
							proto = lamp_prototypes.HS_2A, movable = true,
						},
						{
							typename = "Spot", position = { 0.108837, 0.847568, -5.459007 },
							direction = {azimuth = math.rad(-55.0), elevation = math.rad(0)}, -- argument = 190,
							proto = lamp_prototypes.ANO_3_Kr, angle_max = math.rad(110.0), angle_min = math.rad(0),
						},
						{
							typename = "Spot", position = { 0.108837, 0.847568, 5.463575 },
							direction = {azimuth = math.rad(55.0), elevation = math.rad(0)}, -- argument = 191,
							proto = lamp_prototypes.ANO_3_Zl, angle_max = math.rad(110.0), angle_min = math.rad(0),
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
								typename = "Spot",  position = { 2.000, -0.400, 0.250 },
								direction = {azimuth = math.rad(0), elevation = math.rad(6.0)}, argument = 51,
								proto = lamp_prototypes.LFS_P_27_1000, intensity_max = 1000.0, angle_max = math.rad(21.0), angle_min = math.rad(0), cool_down_t = 0.8,
								exposure = {{0, 0.9, 1.0}}, movable = true,
							},
							{
								typename = "Spot",  position = { 2.000, -0.400, -0.250 },
								direction = {azimuth = math.rad(0), elevation = math.rad(6.0)},
								proto = lamp_prototypes.LFS_P_27_1000, intensity_max = 1000.0, angle_max = math.rad(21.0), angle_min = math.rad(0), cool_down_t = 0.8,
								exposure = {{0, 0.9, 1.0}}, movable = true,
							},
							
							-- Keep taxi lights on
							{
								typename = "Spot",  position = { 2.000, -0.400, 0.250 },
								direction = {azimuth = math.rad(0), elevation = math.rad(8.0)},
								proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(33.3), angle_min = math.rad(0.0), cool_down_t = 0.5,
								exposure = {{0, 0.9, 1.0}}, movable = true,
							},
							{
								typename = "Spot",  position = { 2.000, -0.400, -0.250 },
								direction = {azimuth = math.rad(0), elevation = math.rad(8.0)},
								proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(33.3), angle_min = math.rad(0.0), cool_down_t = 0.5,
								exposure = {{0, 0.9, 1.0}}, movable = true,
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
								typename = "Spot",  position = { 2.000, -0.400, 0.250 },
								direction = {azimuth = math.rad(0), elevation = math.rad(8.0)}, argument = 51,
								proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(33.3), angle_min = math.rad(0.0), cool_down_t = 0.5,
								exposure = {{0, 0.9, 1.0}}, movable = true,
							},
							{
								typename = "Spot",  position = { 2.000, -0.400, -0.250 },
								direction = {azimuth = math.rad(0), elevation = math.rad(8.0)},
								proto = lamp_prototypes.LFS_R_27_250, angle_max = math.rad(33.3), angle_min = math.rad(0.0), cool_down_t = 0.5,
								exposure = {{0, 0.9, 1.0}}, movable = true,
							},						
						},
					},
				},
			},
			
			[WOLALIGHT_STROBES] = {		-- Red beacon lights. Old aircraft have rotating/oscillating ones. Modern aircraft flash.
				typename = "collection",
				lights = {
					[1] = {
						typename = "Collection",
						lights = {
							{
								typename = "natostrobelight", position = { -5.341401, 1.789537, 0.00 },
								proto = lamp_prototypes.MSL_3_2, period = 1.5, 
							},
						},
					},
				},
			},
			
			[WOLALIGHT_AUX_LIGHTS] = {	-- White anti-collision strobes
				typename = "collection",
				lights = {
					[1] = {
						typename = "Collection",
						lights = {						
							{
								typename = "Spot", position = { 0.108837, 0.847568, -5.459007 },
								controller = "VariablePatternStrobe", mode = "1 Flash",
								proto = lamp_prototypes.MPS_1, intensity_max = 150.0, period = 0.333, phase_shift = 0.25,
								direction = {azimuth = math.rad(-90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
							},
							{
								typename = "Spot", position = { 0.108837, 0.847568, 5.463575 },
								controller = "VariablePatternStrobe", mode = "1 Flash",
								proto = lamp_prototypes.MPS_1, intensity_max = 150.0, period = 0.333, phase_shift = 0.25,
								direction = {azimuth = math.rad(90.0), elevation = math.rad(0)}, angle_max = math.rad(180.0), angle_min = math.rad(0),
							},
							{
								typename = "Spot", position = { -6.0, 1.70, 0 },
								controller = "VariablePatternStrobe", mode = "1 Flash",
								proto = lamp_prototypes.MPS_1, intensity_max = 175.0, period = 0.333, phase_shift = 0.25,
								direction = {azimuth = math.rad(180.0), elevation = math.rad(0)}, angle_max = math.rad(160.0), angle_min = math.rad(0),
							},
						},
					},
				},
			},
			
			[WOLALIGHT_CABIN_WORK] = {
				typename = "collection",
				lights = {
					[1] = {
						typename = "collection",
						lights = {
							{
								typename = "omnilight", position = {0.4, 0.200, 0.2574 },
								color = {90/255, 168/255, 190/255, 0.5}, intensity_max = 1.0,
							},
							{
								typename = "omnilight", position = {0.4, 0.200, -0.2574 },
								color = {90/255, 168/255, 190/255, 0.5}, intensity_max = 1.0,
							},
						},
					},
				},
			},
		},
	},
}

add_aircraft(Cessna_210N)