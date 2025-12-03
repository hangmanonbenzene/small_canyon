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

func set_visibility(value: bool) -> void:
	for a_mesh in meshes:
		a_mesh.visible = value

func blocks_space() -> Array[Vector3i]:
	var blocked_space: Array[Vector3i]
	for space in blocker:
		blocked_space.append(Main.get_position(space))
	return blocked_space
