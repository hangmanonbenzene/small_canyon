extends Node3D

@export var menus: Node
@export var main_menu_3d: Node3D
@export var camera: Camera3D
@export var level: Node3D

var objects: Array[Node]

func open_new_level() -> void:
	main_menu_3d.visible = false
	var new_cube: Node = load("res://app/blocks/cube.tscn").instantiate()
	objects.append(new_cube)
	level.add_child(new_cube)
	var another_cube: Node = load("res://app/blocks/cube.tscn").instantiate()
	objects.append(another_cube)
	level.add_child(another_cube)
	another_cube.position = Vector3.UP

func open_level(_level_name: String, _edit_mode: bool) -> void:
	main_menu_3d.visible = false
	var new_cube: Node = load("res://app/blocks/cube.tscn").instantiate()
	objects.append(new_cube)
	level.add_child(new_cube)

func open_main_menu() -> void:
	for block: Node in level.get_children():
		block.queue_free()
	camera.size = 7
	main_menu_3d.visible = true
