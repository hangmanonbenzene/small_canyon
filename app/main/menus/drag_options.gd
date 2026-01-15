extends VBoxContainer

@export var xyz_buttons: Array[Button]
@export var pos_label: Button
@export var neg_label: Button

var current_xyz: int = 0
var pos_value: int = 0:
	set(value):
		pos_label.text = " " + str(value) + " "
		pos_value = value
var neg_value: int = 0:
	set(value):
		neg_label.text = " " + str(value) + " "
		neg_value = value

func _on_button_4_toggled(toggled_on: bool) -> void:
	pass


func _on_axis_pressed(xyz: int) -> void:
	xyz_buttons[current_xyz].disabled = false
	xyz_buttons[xyz].disabled = true
	current_xyz = xyz


func _on_pos_pressed(pos: bool) -> void:
	pos_value = maxi(pos_value + (1 if pos else -1), 0)

func _on_neg_pressed(pos: bool) -> void:
	neg_value = maxi(neg_value + (1 if pos else -1), 0)
