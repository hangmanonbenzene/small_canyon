extends Node

@export var world_3d: Node
@export var main_menu: Control
@export var level_buttons: Control
@export var level_button: PackedScene
@export var are_you_sure: Control
@export var are_you_sure_label: Label
@export var play_ui: Control
@export var edit_ui: Control

var button_to_delete: Control
var level_to_delete: String

func _on_new_button_pressed() -> void:
	main_menu.visible = false
	world_3d.open_new_level()
	edit_ui.visible = true

func _on_play_level_pressed(level_name: String) -> void:
	main_menu.visible = false
	world_3d.open_level(level_name, false)
	play_ui.visible = true

func _on_edit_level_pressed(level_name: String) -> void:
	main_menu.visible = false
	world_3d.open_level(level_name, true)
	edit_ui.visible = true

func _on_delete_level_pressed(button: Control, level_name: String) -> void:
	button_to_delete = button
	level_to_delete = level_name
	are_you_sure_label.text = "Delete " + level_name + "?"
	are_you_sure.visible = true

func _on_actually_delete_pressed() -> void:
	DirAccess.remove_absolute("user://created_levels/" + level_to_delete)
	button_to_delete.queue_free()
	are_you_sure.visible = false

func _on_dont_delete_pressed() -> void:
	are_you_sure.visible = false


func load_levels() -> void:
	for level: String in DirAccess.get_files_at("user://created_levels"):
		var new_button: Control = level_button.instantiate()
		new_button.set_up(self, level)
		level_buttons.add_child(new_button)

func remove_levels() -> void:
	for level: Node in level_buttons.get_children():
		level.queue_free()

func open_main_menu() -> void:
	play_ui.visible = false
	edit_ui.visible = false
	main_menu.visible = true
