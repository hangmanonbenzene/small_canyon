class_name Block extends Node3D

var world3d: World

var current_direction: Vector3i
var current_rotation: int

@export var type: String

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

enum {NEW, INVALID, PLAY, EDIT}
var current_mode: int = NEW

func _ready() -> void:
	var material: BaseMaterial3D = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(1.0, 0.647, 0.0, 0.498)
	for side in sides:
		side.material_override = material

func change_mode(new_mode: int) -> void:
	current_mode = new_mode

func initialize(mode: bool, world: World) -> void:
	sides[0].material_override.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	if is_entered: side_color = Color.ORANGE
	else: side_color = Color.WHITE
	change_mode(EDIT if mode else PLAY)
	world3d = world

func get_data() -> String:
	var my_position: Vector3i = Main.get_position(self)
	var data_dict: Dictionary = {
		"type" : type,
		"pos" : [my_position.x, my_position.y, my_position.z],
		"dir" : [current_direction.x, current_direction.y, current_direction.z],
		"rot" : current_rotation,
	}
	var sp_sides: Array
	for i in range(connection_points.size()):
		var point: Array
		for entry in connection_points[i].special_sides:
			var side: SideBlock = connection_points[i].special_sides.get(entry)
			point.append([side.type, [entry.x, entry.y, entry.z], side.my_rotation])
		sp_sides.append(point)
	data_dict.set("sides", sp_sides)
	return JSON.stringify(data_dict)

func blocks_space() -> Array[Vector3i]:
	var blocked_space: Array[Vector3i]
	for space in blocker:
		blocked_space.append(Main.get_position(space))
	return blocked_space

func set_new_position(new_position: Vector3i, new_direction: Vector3i, new_rotation: int) -> void:
	global_position = new_position
	current_direction = new_direction
	current_rotation = new_rotation
	rotation_degrees = Main.rotation_in_degrees(new_direction, new_rotation)

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
			var mouse_vector: Vector2 = event.position - current_camera.unproject_position(Main.get_position(current_point))
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
	if current_mode == NEW or current_mode == INVALID: 
		is_entered = true
	elif current_mode == EDIT: 
		is_entered = true
		if not one_is_pressed:
			side_color = Color.ORANGE

func _on_area_3d_mouse_exited() -> void:
	if current_mode == NEW or current_mode == INVALID: 
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
			world3d.block_pressed(current_point)
		if event is InputEventMouseButton and event.pressed and event.button_index == 2:
			world3d.delete_block(self)
