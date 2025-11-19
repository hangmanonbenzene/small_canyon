class_name ConnectionPoint extends CollisionShape3D

@export var block: Block

var depth: int
var block_behind_this: ConnectionPoint

func viable_direction(direction: Vector3) -> bool:
	return not Main.raycast(self, direction, 1).is_empty()
