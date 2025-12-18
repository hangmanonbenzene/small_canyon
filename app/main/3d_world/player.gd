class_name Player extends Node3D

@export var standing_on: NavigationField
@export var starting_on: NavigationField
@export var going_to: NavigationPoint
@export var coming_from: NavigationPoint
var speed: float = 2.5

var path: Path = Path.new()

func reset() -> void:
	position = Vector3.ZERO
	rotation_degrees = Vector3.ZERO
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
		if (not going_to.middle) and (not coming_from.middle):
			path.pop()
			coming_from = going_to
			going_to = path.get_next()
		
		var start_position: Vector3 = global_position
		var end_position: Vector3 = going_to.coordinates.global_position
		var distance: float = start_position.distance_to(end_position)
		var time_to_cross: float = distance / speed
		var progress_to_dest: float = clamp(delta / time_to_cross, 0.0, 1.0)
		if progress_to_dest == 1.0:
			global_position = end_position
			path.pop()
			standing_on = going_to.field
			coming_from = going_to
			_process(delta - time_to_cross)
		else:
			global_position = start_position.lerp(end_position, progress_to_dest)
