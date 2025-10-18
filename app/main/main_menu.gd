extends Node

@export var main_menu: Control

func _on_level_button_pressed() -> void:
	main_menu.visible = false

func _on_editor_button_pressed() -> void:
	main_menu.visible = false

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_new_button_pressed() -> void:
	main_menu.visible = false
