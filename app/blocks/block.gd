@abstract class_name Block extends Node3D

var world3d: World

@export var sides: Array[MeshInstance3D]
var side_color: Color:
	set(value):
		sides[0].material_override.albedo_color = value
		side_color = value

var is_pressed: bool
var current_camera: Camera3D

enum {NEW, PLAY, EDIT}
var current_mode: int = NEW
static var one_is_pressed: bool
var is_entered: bool

func _ready() -> void:
	var material: BaseMaterial3D = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(1.0, 0.647, 0.0, 0.498)
	for side in sides:
		side.material_override = material

func change_mode(edit_mode: bool) -> void:
	if edit_mode: current_mode = EDIT
	else: current_mode = PLAY

func initialize(mode: bool, world: World) -> void:
	if is_entered: side_color = Color.ORANGE
	else: side_color = Color.WHITE
	change_mode(mode)
	world3d = world

@abstract func get_data() -> String

func blocks_space() -> Array[Vector3]:
	return [global_position]

func connection_points() -> Array[Vector3]:
	return [global_position]

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

func _on_area_3d_input_event(camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if current_mode == EDIT:
		if event is InputEventMouseButton and event.pressed and event.button_index == 1:
			is_pressed = true
			one_is_pressed = true
			current_camera = camera
			world3d.block_pressed(self.global_position)
		if event is InputEventMouseButton and event.pressed and event.button_index == 2:
			world3d.delete_block(self)
