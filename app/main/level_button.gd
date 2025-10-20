extends HBoxContainer

@export var name_button: Button
var level_name: String = "###ERROR###"
var menu: Node

func set_up(new_menu: Node, new_name: String) -> void:
	menu = new_menu
	level_name = new_name
	name_button.text = new_name

func _on_play_pressed() -> void:
	if menu.has_method("_on_play_level_pressed"):
		menu._on_play_level_pressed(level_name)
	else:
		level_name = "###ERROR###"

func _on_edit_pressed() -> void:
	if menu.has_method("_on_edit_level_pressed"):
		menu._on_edit_level_pressed(level_name)
	else:
		level_name = "###ERROR###"

func _on_delete_pressed() -> void:
	if menu.has_method("_on_delete_level_pressed"):
		menu._on_delete_level_pressed(self, level_name)
	else:
		level_name = "###ERROR###"
