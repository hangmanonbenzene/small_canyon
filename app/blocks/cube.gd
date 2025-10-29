extends Node3D

@export var sides: Array[MeshInstance3D]
@export var side_color: Color:
	set(value):
		sides[0].material_override.albedo_color = value
		side_color = value
var world3d: Node

enum {NEW, PLAY, EDIT}
var current_mode: int = NEW
static var one_is_pressed: bool
var is_pressed: bool
var is_entered: bool
var current_camera: Camera3D
var blocks: Array[Node3D]
enum direction {UP, DOWN, LEFT, RIGHT, FORWARD, BACK}
var current_length: int
var current_direction: int

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
						block.queue_free()
					blocks.clear()
					current_length = 0
			elif is_entered: 
				side_color = Color.ORANGE
		if is_pressed and event is InputEventMouseMotion:
			var mouse_vector: Vector2 = event.position - current_camera.unproject_position(global_position)
			var step: float = (840 / current_camera.size)
			var length: int = floori((mouse_vector.length() + step / 2) / step)
			if length > current_length:
				for i in range(current_length, length):
					var new_block: Node3D = preload("res://app/blocks/cube.tscn").instantiate()
					blocks.append(new_block)
					self.get_parent_node_3d().add_child(new_block)
					new_block.global_position = self.global_position + Vector3.UP * (i + 1)
			elif length < current_length:
				for i in range(current_length - length):
					blocks.pop_back().queue_free()
			current_length = length
			print(rad_to_deg(mouse_vector.angle()))

func _on_area_3d_input_event(camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if current_mode == EDIT:
		if event is InputEventMouseButton and event.pressed and event.button_index == 1:
			is_pressed = true
			one_is_pressed = true
			current_camera = camera

func _on_area_3d_mouse_entered() -> void:
	if current_mode == EDIT: 
		is_entered = true
		if not one_is_pressed:
			side_color = Color.ORANGE

func _on_area_3d_mouse_exited() -> void:
	if current_mode == EDIT: 
		is_entered = false
		if not one_is_pressed:
			side_color = Color.WHITE

func change_mode(edit_mode: bool) -> void:
	if edit_mode: current_mode = EDIT
	else: current_mode = PLAY

func initialize(mode: bool, world: Node) -> void:
	side_color = Color.WHITE
	change_mode(mode)
	world3d = world
