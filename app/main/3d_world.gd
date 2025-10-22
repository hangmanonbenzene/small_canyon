extends Node3D

@export var menus: Node
@export var main_menu_3d: Node3D
@export var camera: Camera3D
@export var level: Node3D
@export var cube: PackedScene

func open_new_level() -> void:
	main_menu_3d.visible = false
	level.add_child(cube.instantiate())

func open_level(_level_name: String, _edit_mode: bool) -> void:
	main_menu_3d.visible = false
	level.add_child(cube.instantiate())

func open_main_menu() -> void:
	for block: Node in level.get_children():
		block.queue_free()
	camera.size = 7
	menus.open_main_menu()
	main_menu_3d.visible = true
