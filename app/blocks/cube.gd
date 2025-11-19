class_name BlockCube extends Block

func get_data() -> String:
	var my_position: Vector3i = Main.get_position(self)
	var data_dict: Dictionary = {
		"type" : "cube",
		"pos_x" : my_position.x,
		"pos_y" : my_position.y,
		"pos_z" : my_position.z,
	}
	return JSON.stringify(data_dict)
