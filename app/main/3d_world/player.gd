class_name Player extends Node3D

@export var standing_on: NavigationField
@export var starting_on: NavigationField
@export var going_to: NavigationPoint
@export var coming_from: NavigationPoint
var speed: float = 3.0

var path: Path = Path.new()

func reset() -> void:
	position = Vector3.ZERO
	rotation_degrees = Vector3(90, 0, 0)
	standing_on = starting_on
	going_to = starting_on.middle
	coming_from = starting_on.middle
	path.clear()

func set_destination(destination: NavigationField) -> void:
	path = standing_on.find_path_to(destination)

func _process(delta: float) -> void:
	if not path.is_empty():
		var dest: NavigationPoint = path.get_next()
		if dest == going_to and dest == coming_from: 
			path.pop()
			dest = path.get_next()
			if dest == null: return
		if dest == coming_from:
			coming_from = going_to
			going_to = dest
		else:
			going_to = dest
		
		if ((not coming_from.middle) and (not going_to.middle)) or coming_from.flat or going_to.flat:
			move_flat(delta)
		else:
			move_round(delta)
		
		if coming_from == going_to and coming_from.field.side_block.type == World.END:
			standing_on.side_block.block.world3d.menus.level_cleared()
		elif coming_from == going_to and coming_from.field.side_block.type == World.DOOR:
			var other_door: Block = coming_from.field.side_block.block.door_connection
			if other_door != null:
				global_position = other_door.sides[0].door_middle.coordinates.global_position
				save_look_at(other_door.connection_points[0].global_position)
				standing_on = other_door.sides[0].door_middle.field
				coming_from = other_door.sides[0].door_middle
				going_to = other_door.sides[0].door_middle

func move_flat(delta: float) -> void:
	var start_position: Vector3 = global_position
	var end_position: Vector3 = going_to.coordinates.global_position
	var distance: float = start_position.distance_to(end_position)
	var time_to_cross: float = distance / speed
	var progress_to_dest: float = clamp(delta / time_to_cross, 0.0, 1.0)
	if (not going_to.middle) and (not coming_from.middle): 
		progress_to_dest = 1.0
		time_to_cross = 0.0
	if progress_to_dest == 1.0:
		global_position = end_position
		path.pop()
		standing_on = going_to.field
		coming_from = going_to
		_process(delta - time_to_cross)
	else:
		global_position = start_position.lerp(end_position, progress_to_dest)

func move_round(delta: float) -> void:
	var start_position: Vector3 = global_position
	var end_position: Vector3 = going_to.coordinates.global_position
	var rotation_point: Vector3 = coming_from.rotation_point.global_position
	
	var start_vec: Vector3 = start_position - rotation_point
	var end_vec: Vector3 = end_position - rotation_point
	var axis: Vector3 = start_vec.cross(end_vec).normalized()

	var total_angle: float = start_vec.angle_to(end_vec)
	var radius: float = start_vec.length()
	var arc_length: float = radius * total_angle
	var time_to_cross: float = arc_length / speed
	var progress_to_dest: float = clamp(delta / time_to_cross, 0.0, 1.0)
	
	
	if progress_to_dest == 1.0:
		global_position = rotation_point + end_vec.normalized() * radius
		if not going_to.flat_round: save_look_at(rotation_point if going_to.inverse or going_to.walk_inverse else global_position + global_position - rotation_point)
		path.pop()
		standing_on = going_to.field
		coming_from = going_to
		_process(delta - time_to_cross)
	else:
		var current_angle: float = total_angle * progress_to_dest
		var rotated_vec: Vector3 = start_vec.rotated(axis, current_angle)
		global_position = rotation_point + rotated_vec
		if not going_to.flat_round: save_look_at(rotation_point if going_to.inverse or going_to.walk_inverse else global_position + global_position - rotation_point)

func save_look_at(target: Vector3) -> void:
	var dir: Vector3 = (target - global_position).normalized()
	var up: Vector3 = Vector3.UP
	if abs(dir.dot(Vector3.UP)) > 0.99: up = Vector3.FORWARD
	look_at(target, up)
