extends Node

@export var world_3d: Node
@export var main_menu: Control
@export var play_ui: Control
@export var edit_ui: Control
@export var play_pause: Control
@export var edit_pause: Control

func load_levels() -> void:
	main_menu.load_levels()

func open_new_level() -> void:
	main_menu.visible = false
	world_3d.open_new_level()
	edit_ui.visible = true

func open_level(level_name: String, edit_mode: bool) -> void:
	main_menu.visible = false
	world_3d.open_level(level_name, edit_mode)
	play_ui.visible = not edit_mode
	edit_ui.visible = edit_mode

func open_main_menu() -> void:
	play_ui.visible = false
	edit_ui.visible = false
	world_3d.open_main_menu()
	main_menu.visible = true

func _on_play_pause_pressed() -> void:
	play_pause.visible = true

func _on_play_pause_continue_pressed() -> void:
	play_pause.visible = false

func _on_play_pause_edit_pressed() -> void:
	play_pause.visible = false
	play_ui.visible = false
	edit_ui.visible = true

func _on_play_pause_leave_pressed() -> void:
	play_pause.visible = false
	open_main_menu()

func _on_edit_pause_pressed() -> void:
	open_main_menu()
