class_name Main extends Node

@export var world_3d: Node
@export var menus: Node

func _ready() -> void:
	menus.call("load_levels")


static func vector3_to_vector3i(vector: Vector3) -> Vector3i:
	return Vector3i(roundi(vector.x), roundi(vector.y), roundi(vector.z))

static func get_position(node: Node3D) -> Vector3i:
	return vector3_to_vector3i(node.global_position)
