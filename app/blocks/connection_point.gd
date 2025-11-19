class_name ConnectionPoint extends CollisionShape3D

@export var block: Block

var depth: int
var block_behind_this: ConnectionPoint
var special_sides: Dictionary[Vector3i, Node3D]

func viable_direction(direction: Vector3i) -> bool:
	return not Main.raycast(self, direction, 1).is_empty()

func side_active(direction: Vector3i, active: bool) -> Node3D:
	if active: remove_special_side(direction)
	var dic: Dictionary = Main.raycast(self, direction, 1)
	var side: Node3D = dic.get("collider").get_parent()
	side.activate(active)
	return side

func set_special_side(new_side: Node3D, new_direction: Vector3i, new_rotation: int) -> void:
	special_sides.set(new_direction, new_side)
	var side: Node3D = side_active(new_direction, false)
	block.add_child(new_side)
	block.sides.append(new_side)
	new_side.global_position = side.global_position
	set_special_side_rotation(new_direction, new_rotation)

func set_special_side_rotation(new_direction: Vector3i, new_rotation: int) -> void:
	special_sides.get(new_direction).global_rotation_degrees = Main.rotation_in_degrees(new_direction, new_rotation)

func remove_special_side(direction: Vector3i) -> void:
	var side: Node3D = special_sides.get(direction)
	block.remove_child(side)
	block.sides.pop_back()
	side.queue_free()
	special_sides.erase(direction)
