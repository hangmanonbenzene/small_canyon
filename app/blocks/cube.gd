extends Node3D

@export var sides: Array[MeshInstance3D]
@export var side_color: Color:
	set(value):
		sides[0].material_override.albedo_color = value
		side_color = value

func _ready() -> void:
	var material: BaseMaterial3D = StandardMaterial3D.new()
	for side in sides:
		side.material_override = material

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		print("yay")

func _on_area_3d_mouse_entered() -> void:
	side_color = Color.ORANGE

func _on_area_3d_mouse_exited() -> void:
	side_color = Color.WHITE
