class_name BlockArch1x extends Block

func get_data() -> String:
	var my_position: Vector3i = vector3_to_vector3i(global_position)
	var data_dict: Dictionary = {
		"type" : "arch1x",
		"pos_x" : my_position.x,
		"pos_y" : my_position.y,
		"pos_z" : my_position.z,
		"dir_x" : current_direction.x,
		"dir_y" : current_direction.y,
		"dir_z" : current_direction.z,
		"rot"   : current_rotation,
	}
	return JSON.stringify(data_dict)
