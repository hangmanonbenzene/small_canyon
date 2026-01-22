class_name Block extends Node3D

var world3d: World

var current_direction: Vector3i
var current_rotation: int
var start_position: Vector3i

@export var type: int

var movable: bool:
	set(value):
		if value and move_config == null: 
			move_config = MoveConfig.new()
			move_config.blocks.append(self)
			world3d.move_configs.append(move_config)
		elif movable and not value: 
			move_config.blocks.erase(self)
			move_config = null
		movable = value
var mover: int:
	set(value):
		mover = value
		movable = mover > 0
var move_config: MoveConfig

static var id_counter: int
var block_id: int
static var door_id_counter: int
var door_connection_id: int = -1
var door_connection: Block
var show_connected: bool:
	set(value):
		show_connected = value
		update_side_color()
var show_move: bool:
	set(value):
		show_move = value
		update_side_color()

@export var sides: Array[SideBlock]
var material: Material
var base_color: Color = Color.WHITE
@export var blocker: Array[Node3D]
@export var connection_points: Array[ConnectionPoint]

var is_entered: bool:
	set(value):
		is_entered = value
		update_side_color()
var is_pressed: bool:
	set(value):
		is_pressed = value
		update_side_color()
static var one_is_pressed: bool
var is_selected: bool:
	set(value):
		if value: 
			if not selected_one == null or selected_one == self: selected_one.is_selected = false
			selected_one = self
			if type == World.DOOR and not door_connection == null:
					door_connection.show_connected = true
			if movable == true:
				world3d.menus.edit_ui.move_options.set_options(move_config)
		else: 
			if type == World.DOOR and not door_connection == null:
					door_connection.show_connected = false
			if movable == true:
				world3d.menus.edit_ui.move_options.disable()
		is_selected = value
		update_side_color()
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
		if  value == PLAY: is_selected = false
		update_side_color()

func _ready() -> void:
	material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(1.0, 0.647, 0.0, 0.498)
	for side in sides:
		side.material_override = material

func initialize(_mode: bool, world: World, new_color: Color) -> void:
	material.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	base_color = new_color
	update_side_color()
	world3d = world
	start_position = Main.get_position(self)

func get_data() -> String:
	var my_position: Vector3i = Main.get_position(self)
	if type == World.DOOR and door_connection != null:
		if door_connection_id < 0:
			door_connection_id = door_id_counter
			door_id_counter += 1
			door_connection.door_connection_id = door_connection_id
	var data_dict: Dictionary = {
		"type" : type,
		"pos" : [my_position.x, my_position.y, my_position.z],
		"dir" : [current_direction.x, current_direction.y, current_direction.z],
		"rot" : current_rotation,
		"col" : world3d.colors.find(base_color),
		"door" : door_connection_id,
		"id" : id_counter,
	}
	block_id = id_counter
	id_counter += 1
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
				world3d.create_blocks()

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
	if world3d.current_creation_mode == World.BUILD_MODE and not current_mode == PLAY: 
			is_entered = true
	elif world3d.current_creation_mode == World.EDIT_MODE and current_mode == EDIT: 
			is_entered = true

func _on_area_3d_mouse_exited() -> void:
	if world3d.current_creation_mode == World.BUILD_MODE and not current_mode == PLAY:
			is_entered = false
	elif world3d.current_creation_mode == World.EDIT_MODE and current_mode == EDIT: 
			is_entered = false
			is_pressed = false

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
			if world3d.add_move_blocks: 
				if not movable:
					move_config = selected_one.move_config
					move_config.blocks.append(self)
					movable = true
				elif selected_one.move_config.blocks.has(self):
					if selected_one == self:
						world3d.menus.edit_ui.move_options.disable()
					movable = false
				else:
					movable = false
					move_config = selected_one.move_config
					move_config.blocks.append(self)
					movable = true
				show_move = movable
				update_side_color()
			elif type == World.DOOR and not selected_one == null and selected_one.type == World.DOOR and not selected_one == self:
				if not selected_one.door_connection == null:
					selected_one.door_connection.door_connection = null
					if not selected_one.door_connection == self: selected_one.door_connection.show_connected = false
				if not door_connection == null:
					door_connection.door_connection = null
					door_connection.show_connected = false
				selected_one.door_connection = self
				door_connection = selected_one
				show_connected = true
			else: is_selected = true

func update_side_color() -> void:
	if current_mode == NEW: material.albedo_color = Color(1.0, 0.647, 0.0, 0.498)
	elif current_mode == INVALID: material.albedo_color = Color.RED
	elif show_connected or show_move: material.albedo_color = Color.RED
	elif is_selected and is_entered: material.albedo_color = Color.REBECCA_PURPLE
	elif is_selected: material.albedo_color = Color.PURPLE
	elif (is_entered and not one_is_pressed) or is_pressed: material.albedo_color = Color.ORANGE
	else: material.albedo_color = base_color
