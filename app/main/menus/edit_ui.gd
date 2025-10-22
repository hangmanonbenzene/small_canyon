extends Control

@export var menus: Node
@export var edit_pause: Control

func _on_edit_pause_pressed() -> void:
	menus.open_main_menu()
