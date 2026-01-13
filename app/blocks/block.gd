class_name Block extends Node3D

var world3d: World

var current_direction: Vector3i
var current_rotation: int

@export var type: int

@export var sides: Array[SideBlock]
var material: Material
var side_color: Color:
	set(value):
		material.albedo_color = value
		side_color = value
var base_color: Color = Color.WHITE
@export var blocker: Array[Node3D]
@export var connection_points: Array[ConnectionPoint]

var is_entered: bool
var is_pressed: bool
static var one_is_pressed: bool
var is_selected: bool:
	set(value):
		if value: 
			if not selected_one == null: selected_one.is_selected = false
			side_color = Color.REBECCA_PURPLE
			selected_one = self
		else: side_color = base_color
		is_selected = value
static var selected_one: Block
var current_camera: Camera3D
var current_point: ConnectionPoint

enum {NEW, INVALID, PLAY, EDIT}
var current_mode: int = NEW:
	set(value):
		current_mode = value
		for side in sides:
			side.play_mode_active = value == PLAY
		for point in connection_points:
			point.get_parent().input_ray_pickable = value == EDIT
			point.get_parent().process_mode = PROCESS_MODE_INHERIT if value == EDIT else PROCESS_MODE_DISABLED
		if value == NEW: side_color = Color(1.0, 0.647, 0.0, 0.498)
		elif value == INVALID: side_color = Color(1.0, 0.0, 0.0, 1.0)

func _ready() -> void:
	material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(1.0, 0.647, 0.0, 0.498)
	for side in sides:
		side.material_override = material

func initialize(_mode: bool, world: World, new_color: Color) -> void:
	material.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	base_color = new_color
	if is_entered: side_color = Color.ORANGE
	else: side_color = base_color
	world3d = world

func get_data() -> String:
	var my_position: Vector3i = Main.get_position(self)
	var data_dict: Dictionary = {
		"type" : type,
		"pos" : [my_position.x, my_position.y, my_position.z],
		"dir" : [current_direction.x, current_direction.y, current_direction.z],
		"rot" : current_rotation,
		"col" : world3d.colors.find(base_color)
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

func update_blocked_space() -> void:
	var blocked_space: Array[Vector3i] = blocks_space()
	for key: Vector3i in world3d.blocked_space.keys():
		if world3d.blocked_space.get(key) == self:
			if key not in blocked_space: 
				world3d.blocked_space.erase(key)
	for space in blocked_space:
		world3d.blocked_space.set(space, self)

func set_new_position(new_position: Vector3i, new_direction: Vector3i, new_rotation: int) -> void:
	global_position = new_position
	current_direction = new_direction
	current_rotation = new_rotation
	rotation_degrees = Main.rotation_in_degrees(new_direction, new_rotation)

func _input(event: InputEvent) -> void:
	if current_mode == EDIT and world3d.current_creation_mode == World.BUILD_MODE and event is InputEventMouseButton and not event.pressed and event.button_index == 1:
		if is_pressed:
			is_pressed = false
			one_is_pressed = false
			if not is_entered:
				side_color = base_color
				world3d.create_blocks()
		elif is_entered: 
			side_color = Color.ORANGE

func _process(_delta: float) -> void:
	if current_mode == EDIT and world3d.current_creation_mode == World.BUILD_MODE and is_pressed:
		var mouse_vector: Vector2 = get_viewport().get_mouse_position() - current_camera.unproject_position(Main.get_position(current_point))
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
		if current_point.viable_direction(direction, (world3d.selected_block_type == world3d.LADDER)):
			world3d.create_block_preview(direction, length)
		else:
			world3d.create_block_preview(direction, 0)

func _on_area_3d_mouse_entered() -> void:
	if world3d.current_creation_mode == World.BUILD_MODE:
		if current_mode == NEW or current_mode == INVALID: 
			is_entered = true
		elif current_mode == EDIT: 
			is_entered = true
			if not one_is_pressed:
				side_color = Color.ORANGE
	elif world3d.current_creation_mode == World.EDIT_MODE:
		if current_mode == EDIT: 
			is_entered = true
			if is_selected: side_color = Color.REBECCA_PURPLE
			else: side_color = Color.ORANGE

func _on_area_3d_mouse_exited() -> void:
	if world3d.current_creation_mode == World.BUILD_MODE:
		if current_mode == NEW or current_mode == INVALID: 
			is_entered = false
		elif current_mode == EDIT:
			is_entered = false
			if not one_is_pressed:
				side_color = base_color
	elif world3d.current_creation_mode == World.EDIT_MODE:
		if current_mode == EDIT: 
			is_entered = false
			is_pressed = false
			if is_selected: side_color = Color.PURPLE
			else: side_color = base_color

func _on_area_3d_input_event(camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if current_mode == EDIT and world3d.current_creation_mode == World.BUILD_MODE:
		if event is InputEventMouseButton and event.pressed and event.button_index == 1:
			is_pressed = true
			one_is_pressed = true
			current_camera = camera
			current_point = connection_points[_shape_idx]
			world3d.block_pressed(current_point)
		if event is InputEventMouseButton and event.pressed and event.button_index == 2:
			world3d.delete_block(self)
	elif current_mode == EDIT and world3d.current_creation_mode == World.EDIT_MODE:
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
			is_pressed = true
		elif event is InputEventMouseButton and event.is_released() and event.button_index == 1 and is_pressed:
			is_selected = true
