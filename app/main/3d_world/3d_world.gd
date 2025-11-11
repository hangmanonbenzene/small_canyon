class_name World extends Node3D

@export var menus: Node
@export var main_menu_3d: Node3D
@export var camera: Camera3D
@export var level: Node3D

const cube: PackedScene = preload("res://app/blocks/cube.tscn")
const arch2x: PackedScene = preload("res://app/blocks/arch_2x.tscn")

var objects: Array[Block]
var blocked_space: Dictionary[Vector3, Block]
var map2d: Dictionary[Vector2, Block]
var current_mode: bool

enum {CUBE, STAIRS, ARCH1X, ARCH2X, ARCH3X, RAMP1X, RAMP2X, RAMP3X, LADDER, DOOR, START, END}
var selected_block_type: int = CUBE
var blocks: Array[Block]
var current_pressed_block_coordinates: Vector3
var current_length: int
var current_direction: Vector3

func open_new_level() -> void:
	main_menu_3d.visible = false
	current_mode = true
	create_new_block(cube.instantiate(), Vector3.ZERO)

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
		match node_data["type"]:
			"cube":
				var new_cube: BlockCube = cube.instantiate()
				create_new_block(new_cube, Vector3(node_data["pos_x"], node_data["pos_y"], node_data["pos_z"]))
			_:
				print("Unknown type!")

func open_main_menu() -> void:
	for object in objects:
		object.queue_free()
	objects.clear()
	blocked_space.clear()
	map2d.clear()
	#camera.size = 7
	main_menu_3d.visible = true

func change_mode(edit_mode: bool) -> void:
	current_mode = edit_mode
	for object in objects:
		object.change_mode(edit_mode)

func create_new_block(new_block: Block, block_position: Vector3) -> void:
	objects.append(new_block)
	level.add_child(new_block)
	new_block.initialize(current_mode, self)
	new_block.global_position = block_position
	for space: Vector3 in new_block.blocks_space():
		blocked_space.set(space, new_block)
	for point3d: Vector3 in new_block.connection_points():
		var point2d: Vector2 = Vector2(point3d.x - point3d.z, point3d.y - point3d.z)
		new_block.depth = point3d.x + point3d.z
		var next_block: Block = map2d.get(point2d)
		if next_block == null or new_block.depth > next_block.depth:
			map2d.set(point2d, new_block)
			new_block.block_behind_this = next_block
			break
		var previous_block: Block = next_block
		next_block = next_block.block_behind_this
		while next_block != null and new_block.depth < next_block.depth:
			previous_block = next_block
			next_block = next_block.block_behind_this
		previous_block.block_behind_this = new_block
		new_block.block_behind_this = next_block

func delete_block(block: Block) -> void:
	if objects.size() <= 1: return
	objects.erase(block)
	for vector_to_remove: Vector3 in block.blocks_space():
		blocked_space.erase(vector_to_remove)
	for point3d: Vector3 in block.connection_points():
		var point2d: Vector2 = Vector2(point3d.x - point3d.z, point3d.y - point3d.z)
		var current_node: Block = map2d.get(point2d)
		if current_node == block: 
			map2d.set(point2d, block.block_behind_this)
			break
		if current_node.block_behind_this != block:
			current_node = current_node.block_behind_this
		current_node.block_behind_this = block.block_behind_this
	level.remove_child(block)
	block.queue_free()

func get_data() -> Array[String]:
	var data: Array[String]
	for block: Block in level.get_children():
		data.append(block.get_data())
	return data

func change_selected_block_type(new_block_type: int) -> void:
	selected_block_type = new_block_type

func block_pressed(coordinates: Vector3) -> void:
	current_pressed_block_coordinates = coordinates

func create_block_preview(direction: Vector3, length: int) -> void:
	if length > current_length:
		for i in range(current_length, length):
			var new_position: Vector3 = current_pressed_block_coordinates + current_direction * (i + 1)
			if new_position in blocked_space:
				length = i
				break
			var new_block: Block = cube.instantiate()
			blocks.append(new_block)
			level.add_child(new_block)
			new_block.global_position = new_position
	elif length < current_length:
		for i in range(current_length - length):
			blocks.pop_back().queue_free()
	current_length = length
	
	if direction != current_direction:
		current_direction = direction
		var is_blocked: bool = false
		for i in blocks.size():
			var new_position: Vector3 = current_pressed_block_coordinates + current_direction * (i + 1)
			if new_position in blocked_space:
				length = i
				is_blocked = true
				break
			blocks[i].global_position = new_position
		if is_blocked:
			for i in range(current_length - length):
				blocks.pop_back().queue_free()
			current_length = length

func create_blocks() -> void:
	for block in blocks:
		var block_position: Vector3 = block.global_position
		level.remove_child(block)
		create_new_block(block, block_position)
	blocks.clear()
	current_length = 0
	current_direction = Vector3.ZERO
