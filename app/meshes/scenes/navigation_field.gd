class_name NavigationField extends Area3D

@export var side_block: SideBlock

func _on_side_clicked(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		print(side_block.type)
