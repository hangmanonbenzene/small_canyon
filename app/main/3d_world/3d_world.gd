class_name World extends Node3D

@export var menus: Node
@export var main_menu_3d: Node3D
@export var environment: MyEnvirement
@export var level: Node3D

const block_prefabs: Array[PackedScene] = [
	preload("res://app/blocks/cube.tscn"),
	preload("res://app/blocks/stairs.tscn"),
	preload("res://app/blocks/arch_1x.tscn"),
	preload("res://app/blocks/arch_2x.tscn"),
	preload("res://app/blocks/arch_3x.tscn"),
	preload("res://app/blocks/ramp_1x.tscn"),
	preload("res://app/blocks/ramp_2x.tscn"),
	preload("res://app/blocks/ramp_3x.tscn"),
	preload("res://app/blocks/door.tscn"),
	preload("res://app/blocks/side_blocks/ladder.tscn"),
	preload("res://app/blocks/side_blocks/start.tscn"),
	preload("res://app/blocks/side_blocks/end.tscn"),
]

var objects: Array[Block]
var blocked_space: Dictionary[Vector3i, Block]
var connection_points: Dictionary[Vector3i, ConnectionPoint]
var map2d: Dictionary[Vector2i, ConnectionPoint]
var current_mode: bool:
	set(value):
		current_mode = value
		environment.mode = environment.MODE2D if value else environment.DISABLED
		for object in objects:
			object.current_mode = Block.EDIT if value else Block.PLAY
		if not value:
			player_position = start_position.player if start_position != null else null
		if player_position != null:
			player_position.reset()

enum {CUBE, STAIRS, ARCH1X, ARCH2X, ARCH3X, RAMP1X, RAMP2X, RAMP3X, DOOR, LADDER, START, END}
var selected_block_type: int = CUBE
var block_types: Array[int] = [0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2]
var blocks_preview: Array[Block]
var sideblock_preview: SideBlock
var current_pressed_block: ConnectionPoint
var current_length: int
var current_direction: Vector3i

var start_position: SideBlock
var end_position: SideBlock
var player_position: Player

func open_new_level() -> void:
	main_menu_3d.visible = false
	create_new_block(block_prefabs[CUBE].instantiate(), Vector3i.ZERO, Vector3i.UP, 0)
	current_mode = true

func open_level(level_name: String, edit_mode: bool) -> void:
	main_menu_3d.visible = false
	if not FileAccess.file_exists("user://created_levels/" + level_name): return
	var save_file: FileAccess = FileAccess.open("user://created_levels/" + level_name, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string: String = save_file.get_line()
		var json: JSON = JSON.new()
		var parse_result: Error = json.parse(json_string)
		if not parse_result == OK: continue
		var node_data: Dictionary = json.data
		if block_prefabs[node_data["type"]] == null: continue
		var block_prefab: Block = block_prefabs[node_data["type"] as int].instantiate()
		var block_position: Vector3i = Vector3i(node_data["pos"][0], node_data["pos"][1], node_data["pos"][2])
		var block_direction: Vector3i = Vector3i(node_data["dir"][0], node_data["dir"][1], node_data["dir"][2])
		var new_block: Block = create_new_block(block_prefab, block_position, block_direction, node_data["rot"])
		await get_tree().create_timer(0.02).timeout
		var sides: Array = node_data["sides"]
		for i in range(sides.size()):
			var point: ConnectionPoint = new_block.connection_points[i]
			for j in range(sides[i].size()):
				var new_side: SideBlock = block_prefabs[sides[i][j][0] as int].instantiate()
				if sides[i][j][0] as int == START: start_position = new_side
				var direction: Vector3i = Vector3i(sides[i][j][1][0], sides[i][j][1][1], sides[i][j][1][2])
				point.set_special_side(new_side, direction, sides[i][j][2])
				point.activate_special_side(direction)
	current_mode = edit_mode

func open_main_menu() -> void:
	for object in objects:
		object.queue_free()
	objects.clear()
	blocked_space.clear()
	connection_points.clear()
	map2d.clear()
	environment.mode = environment.DISABLED
	main_menu_3d.visible = true

func create_new_block(new_block: Block, block_position: Vector3i, block_direction: Vector3i, block_rotation: int) -> Block:
	objects.append(new_block)
	level.add_child(new_block)
	new_block.initialize(current_mode, self)
	new_block.set_new_position(block_position, block_direction, block_rotation)
	for space in new_block.blocks_space():
		blocked_space.set(space, new_block)
	for connection in new_block.connection_points:
		connection_points.set(Main.get_position(connection), connection)
	for i in range(new_block.connection_points.size()):
		var point: ConnectionPoint = new_block.connection_points[i]
		var point3d: Vector3i = Main.get_position(point)
		var point2d: Vector2i = Vector2i(point3d.x - point3d.z, 2 * point3d.y - point3d.x - point3d.z)
		point.depth = point3d.x + point3d.y + point3d.z
		var next_point: ConnectionPoint = map2d.get(point2d)
		if next_point == null or point.depth > next_point.depth:
			map2d.set(point2d, point)
			point.block_behind_this = next_point
			continue
		var previous_point: ConnectionPoint = next_point
		next_point = next_point.block_behind_this
		while next_point != null and point.depth < next_point.depth:
			previous_point = next_point
			next_point = next_point.block_behind_this
		previous_point.block_behind_this = point
		point.block_behind_this = next_point
	return new_block

func delete_block(block: Block) -> void:
	if objects.size() <= 1: return
	objects.erase(block)
	for vector_to_remove in block.blocks_space():
		blocked_space.erase(vector_to_remove)
	for connection in block.connection_points:
		connection_points.erase(Main.get_position(connection))
	for i in range(block.connection_points.size()):
		var point: ConnectionPoint = block.connection_points[i]
		var point3d: Vector3i = Main.get_position(point)
		var point2d: Vector2i = Vector2i(point3d.x - point3d.z, 2 * point3d.y - point3d.x - point3d.z)
		var current_point: ConnectionPoint = map2d.get(point2d)
		if current_point == point: 
			map2d.set(point2d, point.block_behind_this)
			continue
		while current_point.block_behind_this != point:
			current_point = current_point.block_behind_this
		current_point.block_behind_this = point.block_behind_this
	block.queue_free()

func get_data() -> Array[String]:
	var data: Array[String]
	for block: Block in level.get_children():
		data.append(block.get_data())
	return data

func change_selected_block_type(new_block_type: int) -> void:
	selected_block_type = new_block_type

func block_pressed(block: ConnectionPoint) -> void:
	current_pressed_block = block

func create_block_preview(direction: Vector3i, length: int) -> void:
	if current_length == length and current_direction == direction: return
	if block_types[selected_block_type] == 0:
		if length > current_length:
			for i in range(current_length, length):
				var new_position: Vector3i = Main.get_position(current_pressed_block) + current_direction * (i + 1)
				var is_blocked: bool = false
				if new_position in blocked_space: is_blocked = true
				var new_block: Block = block_prefabs[selected_block_type].instantiate()
				blocks_preview.append(new_block)
				level.add_child(new_block)
				new_block.set_new_position(new_position, direction, (length - 1) % 4)
				if is_blocked: new_block.current_mode = Block.INVALID
		elif length < current_length:
			for i in range(current_length - length):
				blocks_preview.pop_back().queue_free()
		current_length = length
		if direction != current_direction:
			current_direction = direction
			for i in blocks_preview.size():
				var new_position: Vector3i = Main.get_position(current_pressed_block) + current_direction * (i + 1)
				var is_blocked: bool = false
				if new_position in blocked_space:
					is_blocked = true
				blocks_preview[i].set_new_position(new_position, direction, (length - 1) % 4)
				blocks_preview[i].current_mode = Block.INVALID if is_blocked else Block.NEW
	elif block_types[selected_block_type] == 1:
		if current_length == 0 and length > 0:
			var new_position: Vector3i = Main.get_position(current_pressed_block) + direction
			var new_block: Block = block_prefabs[selected_block_type].instantiate()
			blocks_preview.append(new_block)
			level.add_child(new_block)
			new_block.set_new_position(new_position, direction, (length - 1) % 4)
			for space in new_block.blocks_space():
				if space in blocked_space:
					new_block.change_mode(Block.INVALID)
					break
		elif current_length > 0 and length > 0:
			if current_direction != direction or current_length != length:
				var new_position: Vector3i = Main.get_position(current_pressed_block) + direction
				blocks_preview[0].set_new_position(new_position, direction, (length - 1) % 4)
				var is_blocked: bool = false
				for space in blocks_preview[0].blocks_space():
					if space in blocked_space:
						is_blocked = true
						break
				blocks_preview[0].current_mode = Block.INVALID if is_blocked else Block.NEW
		elif current_length > 0 and length == 0:
			blocks_preview.pop_back().queue_free()
		current_direction = direction
		current_length = length
	elif block_types[selected_block_type] == 2:
		if current_length == 0 and length > 0:
			var new_block: SideBlock = block_prefabs[selected_block_type].instantiate()
			sideblock_preview = new_block
			current_pressed_block.set_special_side(new_block, direction, length)
			for space in new_block.blocks_space():
				if space in blocked_space:
					new_block.invalid = true
					break
		elif current_length > 0 and length > 0:
			current_pressed_block.reactivate_side(current_direction)
			var new_block: SideBlock = block_prefabs[selected_block_type].instantiate()
			sideblock_preview = new_block
			current_pressed_block.set_special_side(new_block, direction, length)
			for space in new_block.blocks_space():
				if space in blocked_space:
					new_block.invalid = true
					break
		elif current_length > 0 and length == 0:
			current_pressed_block.reactivate_side(current_direction)
			sideblock_preview = null
		current_direction = direction
		current_length = length

func create_blocks() -> void:
	if block_types[selected_block_type] == 2 and current_length > 0:
		if sideblock_preview.invalid:
			current_pressed_block.reactivate_side(current_direction)
		else:
			current_pressed_block.activate_special_side(current_direction)
			if selected_block_type == START: 
				if start_position != null:
					var start_direction: Vector3i = start_position.connection_point.special_sides.find_key(start_position)
					start_position.connection_point.reset_side(start_direction)
				start_position = sideblock_preview
			elif selected_block_type == END: 
				if end_position != null:
					var end_direction: Vector3i = end_position.connection_point.special_sides.find_key(end_position)
					end_position.connection_point.reset_side(end_direction)
				end_position = sideblock_preview
		sideblock_preview = null
	var block_positions: Array[Vector3i]
	for block in blocks_preview:
		block_positions.append(Main.get_position(block))
		level.remove_child(block)
	for i in range(blocks_preview.size()):
		var overflow: float = 0.0
		if blocks_preview[i].current_mode == Block.NEW:
			create_new_block(blocks_preview[i], block_positions[i], current_direction, (current_length - 1))
			blocks_preview[i].current_mode = Block.EDIT if current_mode else Block.PLAY
			overflow = await Main.place_block_animation(blocks_preview[i], current_direction, 0.03, overflow)
		else:
			blocks_preview[i].queue_free()
	blocks_preview.clear()
	current_length = 0
	current_direction = Vector3i.ZERO

func _input(event: InputEvent) -> void:
	if current_mode and event.is_action_pressed("toggle_cam"):
		environment.mode = environment.MODE3D if environment.mode == environment.MODE2D else environment.MODE2D
	
