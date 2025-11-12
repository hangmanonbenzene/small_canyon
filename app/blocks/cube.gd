class_name BlockCube extends Block

func connection_points() -> Array[Vector3i]:
	return [global_position]

func get_data() -> String:
	var data_dict: Dictionary = {
		"type" : "cube",
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"pos_z" : global_position.z,
	}
	return JSON.stringify(data_dict)
