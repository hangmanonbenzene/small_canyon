class_name BlockCube extends Block

func blocks_space() -> Array[Vector3]:
	return [global_position]

func connection_points() -> Array[Vector3]:
	return [global_position]

func get_data() -> String:
	var data_dict: Dictionary = {
		"type" : "cube",
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"pos_z" : global_position.z,
	}
	return JSON.stringify(data_dict)
