class_name Toggle extends Button

@export var buttons: Array[Button]
@export var other_toggles: Array[Toggle]

func _on_toggled(toggled_on: bool) -> void:
	for button: Button in buttons:
		button.visible = toggled_on
	if toggled_on:
		for toggle: Toggle in other_toggles:
			toggle.button_pressed = false
