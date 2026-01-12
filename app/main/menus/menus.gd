extends Node

@export var world_3d: World
@export var main_menu: Control
@export var play_ui: Control
@export var edit_ui: Control

func load_levels() -> void:
	main_menu.load_levels()

func open_new_level() -> void:
	main_menu.set_active(false)
	world_3d.open_new_level()
	edit_ui.set_level_name("")
	edit_ui.set_active(true)

func open_level(level_name: String, edit_mode: bool) -> void:
	main_menu.set_active(false)
	world_3d.open_level(level_name, edit_mode)
	edit_ui.set_level_name(level_name)
	play_ui.set_active(not edit_mode)
	edit_ui.set_active(edit_mode)

func open_main_menu() -> void:
	play_ui.set_active(false)
	edit_ui.set_active(false)
	world_3d.open_main_menu()
	main_menu.set_active(true)

func change_level_mode(edit_mode: bool) -> void:
	play_ui.set_active(not edit_mode)
	edit_ui.set_active(edit_mode)
	world_3d.current_mode = edit_mode

func change_selected_block_type(new_block_type: int) -> void:
	world_3d.change_selected_block_type(new_block_type)

func change_selected_color_type(new_color_type: int) -> void:
	world_3d.change_selected_color_type(new_color_type)

func toggle_edit_menu(on: bool) -> void:
	if on: world_3d.environment.mode = MyEnvirement.PAUSE2D if world_3d.environment.mode == MyEnvirement.MODE2D else MyEnvirement.PAUSE3D
	else: world_3d.environment.mode = MyEnvirement.MODE2D if world_3d.environment.mode == MyEnvirement.PAUSE2D else MyEnvirement.MODE3D
