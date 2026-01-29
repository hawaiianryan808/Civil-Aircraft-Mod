local function add_structure(f)
	if(f) then
		f.shape_table_data = 
		{
			{
				file  	    = f.ShapeName,
				life		= f.Life,
				username    = f.Name,
				desrt       = f.ShapeNameDestr or "self",
			    classname 	= f.classname   or "lLandVehicle",
				positioning = f.positioning or "ADD_HEIGTH" -- {"BYNORMAL", "ONLYHEIGTH", "BY_XZ", "ADD_HEIGTH"}
			}
		}
		if f.ShapeNameDestr then
			f.shape_table_data[#f.shape_table_data + 1] = 
			{
				name  = f.ShapeNameDestr,
				file  = f.ShapeNameDestr,	
			}
		end
		
		
		f.mapclasskey = "P0091000076";
		f.attribute = {wsType_Static, wsType_Standing}
		
		add_surface_unit(f)
		GT = nil;
	else
		error("Can't add structure")
	end;
end
---------- Vehicles ----------
add_structure({
Name 		 =  "CAM_baggage_trailer",  -- CAM_baggage_trailer
DisplayName  = _("CAM - Baggage Trailer"),
ShapeName	 =   "CAM_baggage_trailer",
ShapeNameDestr = "oblomok-4",
Life		 =  10,
Rate		 =  5,
category     =  'ADEquipment',
SeaObject    = 	false,
isPutToWater =  false,
})
add_structure({
Name 		 =  "CAM_rescue6",  -- CAM_rescue6
DisplayName  = _("CAM - Rescue 6 Truck"),
ShapeName	 =   "CAM_rescue6",
ShapeNameDestr = "oblomok-4",
Life		 =  10,
Rate		 =  5,
category     =  'ADEquipment',
SeaObject    = 	false,
isPutToWater =  false,
})
add_structure({
Name 		 =  "CAM_tankwagen",  -- CAM_Tanker
DisplayName  = _("CAM - Tank Truck"),
ShapeName	 =   "CAM_tankwagen",
ShapeNameDestr = "oblomok-4",
Life		 =  10,
Rate		 =  5,
category     =  'ADEquipment',
SeaObject    = 	false,
isPutToWater =  false,
})
add_structure({
Name 		 =  "CAM_TOW_Bar01",  -- CAM_TOW_Bar01
DisplayName  = _("CAM - Tow Bar"),
ShapeName	 =   "CAM_TOW_Bar01",
ShapeNameDestr = "oblomok-4",
Life		 =  10,
Rate		 =  5,
category     =  'ADEquipment',
SeaObject    = 	false,
isPutToWater =  false,
})
add_structure({
Name 		 =  "CAM_tow_tractor",  -- CAM_tow_tractor
DisplayName  = _("CAM - Tow Tractor"),
ShapeName	 =   "CAM_tow_tractor",
ShapeNameDestr = "oblomok-4",
Life		 =  10,
Rate		 =  5,
category     =  'ADEquipment',
SeaObject    = 	false,
isPutToWater =  false,
})
add_structure({
Name 		 =  "CAM_trailer",  -- CAM_trailer
DisplayName  = _("CAM - Trailer"),
ShapeName	 =   "CAM_trailer",
ShapeNameDestr = "oblomok-4",
Life		 =  10,
Rate		 =  5,
category     =  'ADEquipment',
SeaObject    = 	false,
isPutToWater =  false,
})
add_structure({
Name 		 =  "CAM_trailer_container",  -- CAM_trailer_container
DisplayName  = _("CAM - Trailer Container"),
ShapeName	 =   "CAM_trailer_container",
ShapeNameDestr = "oblomok-4",
Life		 =  10,
Rate		 =  5,
category     =  'ADEquipment',
SeaObject    = 	false,
isPutToWater =  false,
})