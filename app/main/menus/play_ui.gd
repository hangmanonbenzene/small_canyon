extends Control

@export var menus: Node
@export var play_pause: Control

func _on_play_pause_pressed() -> void:
	play_pause.visible = true

func _on_play_pause_continue_pressed() -> void:
	play_pause.visible = false

func _on_play_pause_edit_pressed() -> void:
	play_pause.visible = false
	menus.change_level_mode(true)

func _on_play_pause_leave_pressed() -> void:
	play_pause.visible = false
	menus.open_main_menu()
