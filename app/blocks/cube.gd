class_name BlockCube extends Block

var depth: int
var block_behind_this: Block

func _input(event: InputEvent) -> void:
	if current_mode == EDIT:
		if event is InputEventMouseButton and not event.pressed and event.button_index == 1:
			if is_pressed:
				is_pressed = false
				one_is_pressed = false
				if not is_entered:
					side_color = Color.WHITE
					world3d.create_blocks()
			elif is_entered: 
				side_color = Color.ORANGE
		if event is InputEventMouseMotion and is_pressed:
			var mouse_vector: Vector2 = event.position - current_camera.unproject_position(global_position)
			var step: float = (840 / current_camera.size)
			var length: int = clampi(floori((mouse_vector.length() + step / 2) / step), 0, 10)
			var angle: float = rad_to_deg(mouse_vector.angle())
			var direction: Vector3 = (
				Vector3.LEFT if angle < -120
				else Vector3.UP if angle < -60
				else Vector3.FORWARD if angle < 0
				else Vector3.RIGHT if angle < 60
				else Vector3.DOWN if angle < 120
				else Vector3.BACK
			)
			world3d.create_block_preview(direction, length)

func get_data() -> String:
	var data_dict: Dictionary = {
		"type" : "cube",
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"pos_z" : global_position.z,
	}
	return JSON.stringify(data_dict)
