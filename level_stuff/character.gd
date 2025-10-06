@tool
extends Node3D

@export var priority: int:
	set(value):
		priority = value
		$Node3D/MeshInstance3D.material_override.render_priority = value
		$Node3D/MeshInstance3D2.material_override.render_priority = value
