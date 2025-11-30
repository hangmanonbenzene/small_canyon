class_name World extends Node3D

@export var menus: Node
@export var main_menu_3d: Node3D
@export var camera: Camera3D
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
	preload("res://app/blocks/ladder.tscn"),
	null,
	preload("res://app/blocks/start.tscn"),
	null,
]

var objects: Array[Block]
var blocked_space: Dictionary[Vector3i, Block]
var connection_points: Dictionary[Vector3i, ConnectionPoint]
var map2d: Dictionary[Vector2i, ConnectionPoint]
var current_mode: bool

enum {CUBE, STAIRS, ARCH1X, ARCH2X, ARCH3X, RAMP1X, RAMP2X, RAMP3X, LADDER, DOOR, START, END}
var selected_block_type: int = CUBE
var block_types: Array[int] = [0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2]
var blocks_preview: Array[Block]
var current_pressed_block: ConnectionPoint
var current_length: int
var current_direction: Vector3i

var start_position: SideBlock

func open_new_level() -> void:
	main_menu_3d.visible = false
	current_mode = true
	create_new_block(block_prefabs[CUBE].instantiate(), Vector3i.ZERO, Vector3i.UP, 0)

func open_level(level_name: String, edit_mode: bool) -> void:
	main_menu_3d.visible = false
	current_mode = edit_mode
	if not FileAccess.file_exists("user://created_levels/" + level_name): return
	var save_file: FileAccess = FileAccess.open("user://created_levels/" + level_name, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string: String = save_file.get_line()
		var json: JSON = JSON.new()
		var parse_result: Error = json.parse(json_string)
		if not parse_result == OK: continue
		var node_data: Dictionary = json.data
		var new_block: Block
		match node_data["type"]:
			"cube":
				new_block = create_new_block(block_prefabs[CUBE].instantiate(), Vector3i(node_data["pos"][0], node_data["pos"][1], node_data["pos"][2]), Vector3i.UP, 0)
			"stairs":
				new_block = create_new_block(block_prefabs[STAIRS].instantiate(), Vector3i(node_data["pos"][0], node_data["pos"][1], node_data["pos"][2]), Vector3i(node_data["dir"][0], node_data["dir"][1], node_data["dir"][2]), node_data["rot"])
			"arch1x":
				new_block = create_new_block(block_prefabs[ARCH1X].instantiate(), Vector3i(node_data["pos"][0], node_data["pos"][1], node_data["pos"][2]), Vector3i(node_data["dir"][0], node_data["dir"][1], node_data["dir"][2]), node_data["rot"])
			"arch2x":
				new_block = create_new_block(block_prefabs[ARCH2X].instantiate(), Vector3i(node_data["pos"][0], node_data["pos"][1], node_data["pos"][2]), Vector3i(node_data["dir"][0], node_data["dir"][1], node_data["dir"][2]), node_data["rot"])
			"arch3x":
				new_block = create_new_block(block_prefabs[ARCH3X].instantiate(), Vector3i(node_data["pos"][0], node_data["pos"][1], node_data["pos"][2]), Vector3i(node_data["dir"][0], node_data["dir"][1], node_data["dir"][2]), node_data["rot"])
			"ramp1x":
				new_block = create_new_block(block_prefabs[RAMP1X].instantiate(), Vector3i(node_data["pos"][0], node_data["pos"][1], node_data["pos"][2]), Vector3i(node_data["dir"][0], node_data["dir"][1], node_data["dir"][2]), node_data["rot"])
			"ramp2x":
				new_block = create_new_block(block_prefabs[RAMP2X].instantiate(), Vector3i(node_data["pos"][0], node_data["pos"][1], node_data["pos"][2]), Vector3i(node_data["dir"][0], node_data["dir"][1], node_data["dir"][2]), node_data["rot"])
			"ramp3x":
				new_block = create_new_block(block_prefabs[RAMP3X].instantiate(), Vector3i(node_data["pos"][0], node_data["pos"][1], node_data["pos"][2]), Vector3i(node_data["dir"][0], node_data["dir"][1], node_data["dir"][2]), node_data["rot"])
			_:
				print("Unknown type!")
		await get_tree().process_frame
		var sides: Array = node_data["sides"]
		for i in range(sides.size()):
			var point: ConnectionPoint = new_block.connection_points[i]
			for j in range(sides[i].size()):
				var new_side: SideBlock
				match sides[i][j][0]:
					"ladder":
						new_side = block_prefabs[LADDER].instantiate()
						new_side.type = "ladder"
					"start":
						new_side = block_prefabs[START].instantiate()
						new_side.type = "start"
						start_position = new_side
				var direction: Vector3i = Vector3i(sides[i][j][1][0], sides[i][j][1][1], sides[i][j][1][2])
				point.set_special_side(new_side, direction, sides[i][j][2])
				point.activate_special_side(direction)

func open_main_menu() -> void:
	for object in objects:
		object.queue_free()
	objects.clear()
	blocked_space.clear()
	connection_points.clear()
	map2d.clear()
	#camera.size = 7
	main_menu_3d.visible = true

func change_mode(edit_mode: bool) -> void:
	current_mode = edit_mode
	for object in objects:
		object.change_mode(Block.EDIT if edit_mode else Block.PLAY)

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
				if is_blocked: new_block.change_mode(Block.INVALID)
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
				blocks_preview[i].change_mode(Block.INVALID if is_blocked else Block.NEW)
	elif block_types[selected_block_type] == 1:
		if current_length == 0 and length > 0:
			var new_position: Vector3i = Main.get_position(current_pressed_block) + direction
			var new_block: Block = block_prefabs[selected_block_type].instantiate()
			blocks_preview.append(new_block)
			level.add_child(new_block)
			new_block.set_new_position(new_position, direction, (length - 1) % 4)
			var is_blocked: bool = false
			for space in new_block.blocks_space():
				if space in blocked_space:
					is_blocked = true
					break
			if is_blocked: new_block.change_mode(Block.INVALID)
		elif current_length > 0 and length > 0:
			if current_direction != direction or current_length != length:
				var new_position: Vector3i = Main.get_position(current_pressed_block) + direction
				blocks_preview[0].set_new_position(new_position, direction, (length - 1) % 4)
				var is_blocked: bool = false
				for space in blocks_preview[0].blocks_space():
					if space in blocked_space:
						is_blocked = true
						break
				blocks_preview[0].change_mode(Block.INVALID if is_blocked else Block.NEW)
		elif current_length > 0 and length == 0:
			blocks_preview.pop_back().queue_free()
		current_direction = direction
		current_length = length
	elif block_types[selected_block_type] == 2:
		if current_length == 0 and length > 0:
			var new_block: SideBlock = block_prefabs[selected_block_type].instantiate()
			current_pressed_block.set_special_side(new_block, direction, length)
		elif current_length > 0 and length > 0:
			if current_direction == direction:
				current_pressed_block.set_special_side_rotation(direction, length)
			else:
				current_pressed_block.side_active(current_direction, true)
				var new_block: SideBlock = block_prefabs[selected_block_type].instantiate()
				current_pressed_block.set_special_side(new_block, direction, length)
		elif current_length > 0 and length == 0:
			current_pressed_block.side_active(current_direction, true)
		current_direction = direction
		current_length = length

func create_blocks() -> void:
	if block_types[selected_block_type] == 2 and current_length > 0:
		var side: SideBlock = current_pressed_block.activate_special_side(current_direction)
		if selected_block_type == START: 
			if start_position != null:
				var start_direction: Vector3i = start_position.connection_point.special_sides.find_key(start_position)
				start_position.connection_point.reset_side(start_direction)
			start_position = side
	for block in blocks_preview:
		var block_position: Vector3i = Main.get_position(block)
		level.remove_child(block)
		if block.current_mode == Block.NEW:
			create_new_block(block, block_position, current_direction, (current_length - 1))
		else:
			block.queue_free()
	blocks_preview.clear()
	current_length = 0
	current_direction = Vector3i.ZERO
