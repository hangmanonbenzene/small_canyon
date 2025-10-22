extends Node3D

@export var main_menu: Control
@export var main_menu_3d: Node3D
@export var camera: Camera3D
@export var play_ui: Control
@export var edit_ui: Control
@export var level: Node3D
@export var cube: PackedScene

func open_new_level() -> void:
	main_menu_3d.visible = false
	edit_ui.visible = true
	level.add_child(cube.instantiate())

func open_level(_level_name: String, edit_mode: bool) -> void:
	main_menu_3d.visible = false
	if edit_mode:
		edit_ui.visible = true
	else:
		play_ui.visible = true
	level.add_child(cube.instantiate())

func open_main_menu() -> void:
	play_ui.visible = false
	edit_ui.visible = false
	for block: Node in level.get_children():
		block.queue_free()
	camera.size = 7
	main_menu.visible = true
	main_menu_3d.visible = true
