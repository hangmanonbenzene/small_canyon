class_name ConnectionPoint extends CollisionShape3D

@export var block: Block

var depth: int
var block_behind_this: ConnectionPoint

func viable_direction(direction: Vector3) -> bool:
	var start_pos: Vector3 = Main.get_position(self)
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var end_pos: Vector3 = start_pos + (direction / 2)
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(start_pos, end_pos)
	query.exclude = [self]
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 1
	var result: Dictionary = space_state.intersect_ray(query)
	if result: return true
	else: return false
