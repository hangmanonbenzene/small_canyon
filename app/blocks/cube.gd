extends Node3D

@export var sides: Array[MeshInstance3D]
@export var side_color: Color:
	set(value):
		sides[0].material_override.albedo_color = value
		side_color = value
var world3d: Node

var depth: int
var block_behind_this: Node3D

enum {NEW, PLAY, EDIT}
var current_mode: int = NEW
static var one_is_pressed: bool
var is_pressed: bool
var is_entered: bool
var current_camera: Camera3D
var blocks: Array[Node3D]
var current_length: int
var current_direction: Vector3

func _ready() -> void:
	var material: BaseMaterial3D = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(1.0, 0.647, 0.0, 0.498)
	for side in sides:
		side.material_override = material

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

func _on_area_3d_mouse_entered() -> void:
	if current_mode == NEW: 
		is_entered = true
	elif current_mode == EDIT: 
		is_entered = true
		if not one_is_pressed:
			side_color = Color.ORANGE

func _on_area_3d_mouse_exited() -> void:
	if current_mode == NEW: 
		is_entered = false
	elif current_mode == EDIT: 
		is_entered = false
		if not one_is_pressed:
			side_color = Color.WHITE

func change_mode(edit_mode: bool) -> void:
	if edit_mode: current_mode = EDIT
	else: current_mode = PLAY

func initialize(mode: bool, world: Node) -> void:
	if is_entered: side_color = Color.ORANGE
	else: side_color = Color.WHITE
	change_mode(mode)
	world3d = world

func get_data() -> String:
	var data_dict: Dictionary = {
		"type" : "cube",
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"pos_z" : global_position.z,
	}
	return JSON.stringify(data_dict)

func blocks_space() -> Array[Vector3]:
	return [global_position]

func connection_points() -> Array[Vector3]:
	return [global_position]
