class_name SideBlock extends MeshInstance3D

@export var meshes: Array[MeshInstance3D]
@export var type: String

var my_rotation: int

func set_visibility(value: bool) -> void:
	for a_mesh in meshes:
		a_mesh.visible = value
