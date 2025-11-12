class_name ConnectionPoint extends CollisionShape3D

@export var block: Block

var depth: int
var block_behind_this: ConnectionPoint

func get_my_position() -> Vector3i:
	return Block.vector3_to_vector3i(global_position)
