class_name SideBlock extends MeshInstance3D

@export var meshes: Array[MeshInstance3D]
@export var type: int
@export var ladder_possible: bool = true
@export var blocker: Array[Node3D]
var invalid: bool = false:
	set(value):
		if value == true:
			var mat: StandardMaterial3D = StandardMaterial3D.new()
			mat.albedo_color = Color(1.0, 0.0, 0.0, 1.0)
			for a_mesh in meshes:
				a_mesh.material_override = mat
		invalid = value

var my_rotation: int
var connection_point: ConnectionPoint

@export var play_mode_collider: Array[Area3D]
var play_mode_active: bool = false:
	set(value):
		for coll in play_mode_collider:
			coll.input_ray_pickable = value
		play_mode_active = value

func set_visibility(value: bool) -> void:
	for a_mesh in meshes:
		a_mesh.visible = value

func blocks_space() -> Array[Vector3i]:
	var blocked_space: Array[Vector3i]
	for space in blocker:
		blocked_space.append(Main.get_position(space))
	return blocked_space

func _on_side_clicked(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if play_mode_active:
		if event is InputEventMouseButton and event.pressed and event.button_index == 1:
			print(type)
