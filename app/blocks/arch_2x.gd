class_name BlockArch2x extends Block

func blocks_space() -> Array[Vector3]:
	return [global_position]

func connection_points() -> Array[Vector3]:
	return [global_position]

func get_data() -> String:
	return ""
