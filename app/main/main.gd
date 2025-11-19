class_name Main extends Node

@export var world_3d: Node
@export var menus: Node

func _ready() -> void:
	menus.call("load_levels")


static func vector3_to_vector3i(vector: Vector3) -> Vector3i:
	return Vector3i(roundi(vector.x), roundi(vector.y), roundi(vector.z))

static func get_position(node: Node3D) -> Vector3i:
	return vector3_to_vector3i(node.global_position)

static func raycast(start: CollisionShape3D, direction: Vector3, mask: int) -> Dictionary:
	var start_pos: Vector3 = Main.get_position(start)
	var space_state: PhysicsDirectSpaceState3D = start.get_world_3d().direct_space_state
	var end_pos: Vector3 = start_pos + (direction.normalized() / 2)
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(start_pos, end_pos)
	query.exclude = [start]
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = mask
	return space_state.intersect_ray(query)
