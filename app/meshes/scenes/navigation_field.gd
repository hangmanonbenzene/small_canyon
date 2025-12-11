class_name NavigationField extends Area3D

@export var side_block: SideBlock
@export var middle: NavigationPoint

func _on_side_clicked(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if player() != null:
			player().set_destination(self)

func player() -> Player:
	return side_block.block.world3d.player_position

func find_path_to(destination: NavigationField) -> Path:
	var was_already_there: Array[NavigationPoint] = []
	var current_paths: Array[Path] = []
	var next_paths: Array[Path] = []
	was_already_there.append(player().coming_from)
	var new_path: Path = Path.new()
	new_path.append(player().coming_from)
	current_paths.append(new_path)
	if player().coming_from != player().going_to:
		was_already_there.append(player().going_to)
		new_path = Path.new()
		new_path.append(player().going_to)
		current_paths.append(new_path)
	
	if player().coming_from.field == destination:
		new_path = Path.new()
		new_path.append(player().coming_from.field.middle)
		return new_path
	
	if player().going_to.field == destination:
		new_path = Path.new()
		new_path.append(player().going_to.field.middle)
		return new_path
	
	while true:
		for current_path in current_paths:
			var new_points: Array[NavigationPoint] = current_path.back().get_connections()
			for point in new_points:
				if not was_already_there.has(point):
					new_path = current_path.create_copy()
					new_path.append(point)
					next_paths.append(new_path)
					was_already_there.append(point)
					if (point.type == NavigationPoint.MIDDLE_FLAT or point.type == NavigationPoint.MIDDLE_ROUND) and point.field == destination:
						return new_path
		if next_paths.is_empty(): return Path.new()
		else: 
			current_paths = next_paths
			next_paths = []
	return Path.new()
