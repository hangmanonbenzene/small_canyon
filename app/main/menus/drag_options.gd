class_name MoveOptions extends VBoxContainer

@export var add_button: Button
@export var xyz_buttons: Array[Button]
@export var pos_label: Button
@export var neg_label: Button

@export var edit_ui: Control

var current_config: MoveConfig
var current_xyz: int = 0:
	set(value):
		xyz_buttons[current_xyz].disabled = false
		current_xyz = value
		xyz_buttons[current_xyz].disabled = true
var pos_value: int = 0:
	set(value):
		pos_label.text = " " + str(value) + " "
		pos_value = value
var neg_value: int = 0:
	set(value):
		neg_label.text = " " + str(value) + " "
		neg_value = value

func _on_button_4_toggled(toggled_on: bool) -> void:
	World.add_move_blocks = toggled_on


func _on_axis_pressed(xyz: int) -> void:
	current_xyz = xyz
	current_config.xyz = xyz


func _on_pos_pressed(pos: bool) -> void:
	pos_value = maxi(pos_value + (1 if pos else -1), 0)
	current_config.pos = pos_value

func _on_neg_pressed(pos: bool) -> void:
	neg_value = maxi(neg_value + (1 if pos else -1), 0)
	current_config.neg = neg_value

func set_options(new_config: MoveConfig) -> void:
	current_xyz = new_config.xyz
	pos_value = new_config.pos
	neg_value = new_config.neg
	current_config = new_config
	visible = true

func disable() -> void:
	add_button.button_pressed = false
	current_config = null
	visible = false
