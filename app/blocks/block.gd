@abstract class_name Block extends Node3D

var world3d: World

@export var sides: Array[MeshInstance3D]
var side_color: Color:
	set(value):
		sides[0].material_override.albedo_color = value
		side_color = value
@export var blocker: Array[Node3D]
@export var connection_points: Array[ConnectionPoint]

var is_entered: bool
var is_pressed: bool
static var one_is_pressed: bool
var current_camera: Camera3D
var current_point: ConnectionPoint

enum {NEW, PLAY, EDIT}
var current_mode: int = NEW

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
	sides[0].material_override.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	if is_entered: side_color = Color.ORANGE
	else: side_color = Color.WHITE
	change_mode(mode)
	world3d = world

@abstract func get_data() -> String

func blocks_space() -> Array[Vector3i]:
	var blocked_space: Array[Vector3i]
	for space in blocker:
		blocked_space.append(vector3_to_vector3i(space.global_position))
	return blocked_space

func set_new_position(new_position: Vector3i, new_direction: Vector3i, new_rotation: int) -> void:
	global_position = new_position
	match new_direction:
		Vector3i.UP: 
			match new_rotation:
				0: rotation_degrees = Vector3i(0, 0, 0)
				1: rotation_degrees = Vector3i(0, 90, 0)
				2: rotation_degrees = Vector3i(0, 180, 0)
				3: rotation_degrees = Vector3i(0, 270, 0)
		Vector3i.DOWN:
			match new_rotation:
				0: rotation_degrees = Vector3i(0, 0, 180)
				1: rotation_degrees = Vector3i(0, -90, 180)
				2: rotation_degrees = Vector3i(0, -180, 180)
				3: rotation_degrees = Vector3i(0, -270, 180)
		Vector3i.LEFT: 
			match new_rotation:
				0: rotation_degrees = Vector3i(0, 0, 90)
				1: rotation_degrees = Vector3i(-90, 90, 0)
				2: rotation_degrees = Vector3i(0, 180, -90)
				3: rotation_degrees = Vector3i(90, -90, 0)
		Vector3i.RIGHT: 
			match new_rotation:
				0: rotation_degrees = Vector3i(0, 0, -90)
				1: rotation_degrees = Vector3i(90, 90, 0)
				2: rotation_degrees = Vector3i(0, 180, 90)
				3: rotation_degrees = Vector3i(-90, -90, 0)
		Vector3i.FORWARD: 
			match new_rotation:
				0: rotation_degrees = Vector3i(90, 180, 0)
				1: rotation_degrees = Vector3i(0, -90, 90)
				2: rotation_degrees = Vector3i(-90, 0, 0)
				3: rotation_degrees = Vector3i(0, 90, -90)
		Vector3i.BACK: 
			match new_rotation:
				0: rotation_degrees = Vector3i(90, 0, 0)
				1: rotation_degrees = Vector3i(0, 90, 90)
				2: rotation_degrees = Vector3i(-90, 180, 0)
				3: rotation_degrees = Vector3i(0, -90, -90)

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
			var mouse_vector: Vector2 = event.position - current_camera.unproject_position(current_point.get_my_position())
			var step: float = (840 / current_camera.size)
			var length: int = clampi(floori((mouse_vector.length() + step / 2) / step), 0, 10)
			var angle: float = rad_to_deg(mouse_vector.angle())
			var direction: Vector3i = (
				Vector3i.LEFT if angle < -120
				else Vector3i.UP if angle < -60
				else Vector3i.FORWARD if angle < 0
				else Vector3i.RIGHT if angle < 60
				else Vector3i.DOWN if angle < 120
				else Vector3i.BACK
			)
			if current_point.viable_direction(direction):
				world3d.create_block_preview(direction, length)
			else:
				world3d.create_block_preview(direction, 0)

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
			current_point = connection_points[_shape_idx]
			world3d.block_pressed(current_point.get_my_position())
		if event is InputEventMouseButton and event.pressed and event.button_index == 2:
			world3d.delete_block(self)

static func vector3_to_vector3i(vector: Vector3) -> Vector3i:
	return Vector3i(roundi(vector.x), roundi(vector.y), roundi(vector.z))
