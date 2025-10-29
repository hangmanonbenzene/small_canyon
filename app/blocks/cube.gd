class_name BlockCube extends Block

var depth: int
var block_behind_this: Block

var is_pressed: bool
var current_camera: Camera3D
var blocks: Array[Block]
var current_length: int
var current_direction: Vector3

func _input(event: InputEvent) -> void:
	if current_mode == EDIT:
		if event is InputEventMouseButton and not event.pressed and event.button_index == 1:
			if is_pressed:
				is_pressed = false
				one_is_pressed = false
				if not is_entered:
					side_color = Color.WHITE
				for block in blocks:
					var block_position: Vector3 = block.global_position
					self.get_parent_node_3d().remove_child(block)
					world3d.create_new_block(block, block_position)
				blocks.clear()
				current_length = 0
				current_direction = Vector3.ZERO
			elif is_entered: 
				side_color = Color.ORANGE
		if event is InputEventMouseMotion and is_pressed:
			var mouse_vector: Vector2 = event.position - current_camera.unproject_position(global_position)
			var step: float = (840 / current_camera.size)
			var length: int = clampi(floori((mouse_vector.length() + step / 2) / step), 0, 10)
			if length > current_length:
				for i in range(current_length, length):
					var new_position: Vector3 = self.global_position + current_direction * (i + 1)
					if new_position in world3d.blocked_space:
						length = i
						break
					var new_block: Node3D = preload("res://app/blocks/cube.tscn").instantiate()
					blocks.append(new_block)
					self.get_parent_node_3d().add_child(new_block)
					new_block.global_position = new_position
			elif length < current_length:
				for i in range(current_length - length):
					blocks.pop_back().queue_free()
			current_length = length
			var angle: float = rad_to_deg(mouse_vector.angle())
			var direction: Vector3 = (
				Vector3.LEFT if angle < -120
				else Vector3.UP if angle < -60
				else Vector3.FORWARD if angle < 0
				else Vector3.RIGHT if angle < 60
				else Vector3.DOWN if angle < 120
				else Vector3.BACK
			)
			if direction != current_direction:
				current_direction = direction
				var is_blocked: bool = false
				for i in blocks.size():
					var new_position: Vector3 = self.global_position + current_direction * (i + 1)
					if new_position in world3d.blocked_space:
						length = i
						is_blocked = true
						break
					blocks[i].global_position = new_position
				if is_blocked:
					for i in range(current_length - length):
						blocks.pop_back().queue_free()
					current_length = length

func _on_area_3d_input_event(camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if current_mode == EDIT:
		if event is InputEventMouseButton and event.pressed and event.button_index == 1:
			is_pressed = true
			one_is_pressed = true
			current_camera = camera
		if event is InputEventMouseButton and event.pressed and event.button_index == 2:
			world3d.delete_block(self)

func get_data() -> String:
	var data_dict: Dictionary = {
		"type" : "cube",
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"pos_z" : global_position.z,
	}
	return JSON.stringify(data_dict)
