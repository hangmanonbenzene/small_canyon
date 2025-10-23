extends Node3D

@export var side: MeshInstance3D
@export var side_color: Color:
	set(value):
		side.get_surface_override_material(0).albedo_color = value
		side_color = value
		print("test")
