extends Node

@export var main_menu: Control
@export var level_menu: Control
@export var editor_menu: Control

func _on_level_button_pressed() -> void:
	main_menu.visible = false
	level_menu.visible = true
	editor_menu.visible = false


func _on_editor_button_pressed() -> void:
	main_menu.visible = false
	level_menu.visible = false
	editor_menu.visible = true


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	main_menu.visible = true
	level_menu.visible = false
	editor_menu.visible = false
