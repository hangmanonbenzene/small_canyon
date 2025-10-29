extends Node3D

@export var menus: Node
@export var main_menu_3d: Node3D
@export var camera: Camera3D
@export var level: Node3D

var objects: Array[Node]
var current_mode: bool

func open_new_level() -> void:
	main_menu_3d.visible = false
	current_mode = true
	create_new_block(preload("res://app/blocks/cube.tscn").instantiate())

func open_level(_level_name: String, edit_mode: bool) -> void:
	main_menu_3d.visible = false
	current_mode = edit_mode

func open_main_menu() -> void:
	for block: Node in level.get_children():
		block.queue_free()
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
