class_name ConnectionPoint extends CollisionShape3D

@export var block: Block

var depth: int
var block_behind_this: ConnectionPoint

var special_sides: Dictionary[Vector3i, SideBlock]
var new_special_side: SideBlock
var old_sides: Dictionary[Vector3i, CubeSide]
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
	#if door also deactivate more
	
	new_side.connection_point = self
	new_special_side = new_side
	block.add_child(new_side)
	new_side.material_override = block.sides[0].material_override
	new_side.global_position = current_old_side.global_position
	set_special_side_rotation(new_direction, new_rotation)

func set_special_side_rotation(new_direction: Vector3i, new_rotation: int) -> void:
	new_special_side.global_rotation_degrees = Main.rotation_in_degrees(new_direction, new_rotation)
	new_special_side.my_rotation = new_rotation

func reactivate_side(direction: Vector3i) -> SideBlock:
	block.remove_child(new_special_side)
	new_special_side.queue_free()
	new_special_side = null
	current_old_side = null
	return set_visibility(direction, true)

func activate_special_side(direction: Vector3i) -> SideBlock:
	if special_sides.has(direction):
		var old_side: SideBlock = special_sides.get(direction)
		block.remove_child(old_side)
		old_side.queue_free()
	else:
		current_old_side.activate(false)
		old_sides.set(direction, current_old_side)
	special_sides.set(direction, new_special_side)
	current_old_side = null
	return new_special_side

func reset_side(direction: Vector3i) -> void:
	var old_side: CubeSide = old_sides.get(direction)
	old_side.activate(true)
	var current_side: SideBlock = special_sides.get(direction)
	block.remove_child(current_side)
	current_side.queue_free()
	special_sides.erase(direction)
