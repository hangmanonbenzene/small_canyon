extends Control

@export var menus: Node
@export var edit_pause: Control
@export var name_text: LineEdit

@export var build_ui: Control
@export var edit_ui: Control

@export var block_buttons: Array[Button]
var selected_block_type: int
@export var color_buttons: Array[Button]
var selected_color_type: int
@export var mode_buttons: Array[Button]
var selected_mode: int

@export var move_options: Control

var level_name: String

func _on_edit_pause_pressed() -> void:
	edit_pause.visible = true
	menus.toggle_edit_menu(true)
	
func _on_edit_pause_continue_pressed() -> void:
	edit_pause.visible = false
	menus.toggle_edit_menu(false)

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
	for line: String in menus.world_3d.get_data():
		file.store_line(line)
	return true

func _on_block_selection_pressed(block_type: int) -> void:
	block_buttons[selected_block_type].disabled = false
	selected_block_type = block_type
	block_buttons[selected_block_type].disabled = true
	menus.change_selected_block_type(selected_block_type)

func _on_color_selection_pressed(color_type: int) -> void:
	color_buttons[selected_color_type].disabled = false
	selected_color_type = color_type
	color_buttons[selected_color_type].disabled = true
	menus.change_selected_color_type(selected_color_type)

func _on_change_mode(new_mode: int) -> void:
	mode_buttons[selected_mode].disabled = false
	selected_mode = new_mode
	mode_buttons[selected_mode].disabled = true
	build_ui.visible = new_mode == World.BUILD_MODE
	edit_ui.visible = new_mode == World.EDIT_MODE
	menus.change_creation_mode(new_mode)
