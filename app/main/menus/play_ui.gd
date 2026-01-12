extends Control

@export var menus: Node
@export var play_pause: Control
@export var end_screen: Control

func _on_play_pause_pressed() -> void:
	play_pause.visible = true

func _on_play_pause_continue_pressed() -> void:
	play_pause.visible = false

func _on_play_pause_edit_pressed() -> void:
	play_pause.visible = false
	end_screen.visible = false
	menus.change_level_mode(true)

func _on_play_pause_leave_pressed() -> void:
	play_pause.visible = false
	end_screen.visible = false
	menus.open_main_menu()

func set_active(active: bool) -> void:
	visible = active
