extends Node3D

@export var menus: Node
@export var main_menu_3d: Node3D
@export var camera: Camera3D
@export var level: Node3D

const cube: Resource = preload("res://app/blocks/cube.tscn")

var objects: Array[Node]
var blocked_space: Array[Vector3]
var current_mode: bool

func open_new_level() -> void:
	main_menu_3d.visible = false
	current_mode = true
	create_new_block(cube.instantiate())

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
				var new_cube: Node3D = cube.instantiate()
				new_cube.global_position = Vector3(node_data["pos_x"], node_data["pos_y"], node_data["pos_z"])
				create_new_block(new_cube)
			_:
				print("Unknown type!")

func open_main_menu() -> void:
	for object in objects:
		object.queue_free()
	objects.clear()
	blocked_space.clear()
	camera.size = 7
	main_menu_3d.visible = true

func change_mode(edit_mode: bool) -> void:
	current_mode = edit_mode
	for object in objects:
		object.change_mode(edit_mode)

func create_new_block(new_block: Node) -> void:
	objects.append(new_block)
	level.add_child(new_block)
	new_block.initialize(true, self)
	blocked_space.append_array(new_block.blocks_space())

func get_data() -> Array[String]:
	var data: Array[String]
	for block: Node in level.get_children():
		data.append(block.get_data())
	return data
