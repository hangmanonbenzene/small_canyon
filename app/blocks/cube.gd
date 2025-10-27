extends Node3D

@export var side: MeshInstance3D
@export var side_color: Color:
	set(value):
		side.get_surface_override_material(0).albedo_color = value
		side_color = value


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		print("yay")
