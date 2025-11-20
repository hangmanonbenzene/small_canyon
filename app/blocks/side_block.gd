class_name SideBlock extends MeshInstance3D

@export var meshes: Array[MeshInstance3D]

func set_visibility(value: bool) -> void:
	for a_mesh in meshes:
		a_mesh.visible = value
