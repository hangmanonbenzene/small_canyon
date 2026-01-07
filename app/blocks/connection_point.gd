class_name ConnectionPoint extends CollisionShape3D

@export var block: Block

var coordinates_2D: Vector2i
var depth: int
var block_behind_this: ConnectionPoint

var special_sides: Dictionary[Vector3i, SideBlock]
var new_special_side: SideBlock
var current_old_side: SideBlock

func viable_direction(direction: Vector3i, ladder: bool) -> bool:
	var result: Dictionary = Main.raycast(self, direction, 1)
	if result.is_empty(): return false
	if ladder: return result.get("collider").get_parent().ladder_possible
	return true

func set_visibility(direction: Vector3i, visibility: bool) -> SideBlock:
	var side: SideBlock = Main.raycast(self, direction, 1).get("collider").get_parent()
	side.set_visibility(visibility)
	return side

func set_special_side(new_side: SideBlock, new_direction: Vector3i, new_rotation: int) -> void:
	current_old_side = set_visibility(new_direction, false)
	new_side.connection_point = self
	new_side.block = block
	new_special_side = new_side
	block.add_child(new_side)
	new_side.material_override = block.material
	new_side.global_position = current_old_side.global_position
	new_side.global_rotation_degrees = Main.rotation_in_degrees(new_direction, new_rotation)
	new_side.my_rotation = new_rotation

func reactivate_side(direction: Vector3i) -> SideBlock:
	block.remove_child(new_special_side)
	new_special_side.queue_free()
	new_special_side = null
	current_old_side = null
	return set_visibility(direction, true)

func activate_special_side(direction: Vector3i) -> void:
	new_special_side.ladder_possible = current_old_side.ladder_possible
	for blocker in current_old_side.blocker:
		block.blocker.erase(blocker)
	block.blocker.append_array(new_special_side.blocker)
	block.update_blocked_space()
	block.sides.erase(current_old_side)
	block.sides.append(new_special_side)
	block.remove_child(current_old_side)
	current_old_side.queue_free()
	special_sides.set(direction, new_special_side)
	new_special_side = null
	current_old_side = null

func reset_side(direction: Vector3i) -> void:
	var current_side: SideBlock = special_sides.get(direction)
	var new_side: SideBlock = preload("res://app/meshes/scenes/cube.tscn").instantiate()
	new_side.ladder_possible = current_side.ladder_possible
	new_side.connection_point = self
	new_side.block = block
	block.add_child(new_side)
	new_side.material_override = block.material
	new_side.global_position = current_side.global_position
	new_side.global_rotation_degrees = Main.rotation_in_degrees(direction, current_side.my_rotation)
	new_side.my_rotation = current_side.my_rotation
	for blocker in current_side.blocker:
		block.blocker.erase(blocker)
	block.update_blocked_space()
	block.sides.erase(current_side)
	block.sides.append(new_side)
	block.remove_child(current_side)
	current_side.queue_free()
	special_sides.erase(direction)
