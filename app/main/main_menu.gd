extends Control

@export var main_menu_buttons: Control

func _on_level_button_pressed() -> void:
	main_menu_buttons.visible = false


func _on_editor_button_pressed() -> void:
	main_menu_buttons.visible = false


func _on_exit_button_pressed() -> void:
	get_tree().quit()
