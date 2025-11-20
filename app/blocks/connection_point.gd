class_name ConnectionPoint extends CollisionShape3D

@export var block: Block

var depth: int
var block_behind_this: ConnectionPoint

var special_sides: Dictionary[Vector3i, SideBlock]
var new_special_side: SideBlock
var current_old_side: SideBlock

func viable_direction(direction: Vector3i) -> bool:
	return not Main.raycast(self, direction, 1).is_empty()

func side_active(direction: Vector3i, active: bool) -> SideBlock:
	if active: remove_special_side()
	var side: SideBlock = Main.raycast(self, direction, 1).get("collider").get_parent()
	side.set_visibility(active)
	return side

func set_special_side(new_side: SideBlock, new_direction: Vector3i, new_rotation: int) -> void:
	var side: SideBlock = side_active(new_direction, false)
	current_old_side = side
	new_special_side = new_side
	block.add_child(new_side)
	new_side.material_override = block.sides[0].material_override
	new_side.global_position = side.global_position
	set_special_side_rotation(new_direction, new_rotation)

func set_special_side_rotation(new_direction: Vector3i, new_rotation: int) -> void:
	new_special_side.global_rotation_degrees = Main.rotation_in_degrees(new_direction, new_rotation)
	new_special_side.my_rotation = new_rotation

func remove_special_side() -> void:
	var side: SideBlock = new_special_side
	block.remove_child(side)
	side.queue_free()
	new_special_side = null
	current_old_side = null

func activate_special_side(direction: Vector3i) -> SideBlock:
	if special_sides.has(direction):
		var old_side: SideBlock = special_sides.get(direction)
		block.remove_child(old_side)
		old_side.queue_free()
	else:
		current_old_side.activate(false)
	special_sides.set(direction, new_special_side)
	current_old_side = null
	return new_special_side
