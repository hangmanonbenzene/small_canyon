extends Control

@export var menus: Node
@export var edit_pause: Control
@export var name_text: LineEdit

var level_name: String

func _on_edit_pause_pressed() -> void:
	edit_pause.visible = true
	
func _on_edit_pause_continue_pressed() -> void:
	edit_pause.visible = false

func _on_edit_pause_save_and_play_pressed() -> void:
	if save():
		edit_pause.visible = false
		menus.change_level_mode(false)
	else:
		name_text.add_theme_color_override("font_placeholder_color", Color(1.0, 0.0, 0.0, 1.0))
		await get_tree().create_timer(0.5).timeout
		name_text.remove_theme_color_override("font_placeholder_color")

func _on_edit_pause_save_and_exit_pressed() -> void:
	if save():
		edit_pause.visible = false
		menus.open_main_menu()
	else:
		name_text.add_theme_color_override("font_placeholder_color", Color(1.0, 0.0, 0.0, 1.0))
		await get_tree().create_timer(0.5).timeout
		name_text.remove_theme_color_override("font_placeholder_color")

func _on_edit_pause_exit_pressed() -> void:
	edit_pause.visible = false
	menus.open_main_menu()

func set_active(active: bool) -> void:
	visible = active

func set_level_name(new_name: String) -> void:
	level_name = new_name
	name_text.text = new_name

func save() -> bool:
	name_text.text = name_text.text.strip_edges()
	level_name = name_text.text
	if level_name.is_empty(): return false
	var file: FileAccess = FileAccess.open("user://created_levels/" + level_name, FileAccess.WRITE)
	if file == null: return false
	return true
