extends Node

@export var main_menu: Control
@export var level_buttons: Control
@export var level_button: PackedScene

func _on_new_button_pressed() -> void:
	main_menu.visible = false

func _on_play_level_pressed(button: Control, level_name: String) -> void:
	print("play " + level_name)
	main_menu.visible = false

func _on_edit_level_pressed(button: Control, level_name: String) -> void:
	print("edit " + level_name)
	main_menu.visible = false

func _on_delete_level_pressed(button: Control, level_name: String) -> void:
	print("delete " + level_name)
	button.queue_free()

func load_levels() -> void:
	var new_button: Control = level_button.instantiate()
	new_button.set_up(self, "test")
	level_buttons.add_child(new_button)
