class_name Path

var path: Array[NavigationPoint] = []

func is_empty() -> bool:
	return path.is_empty()

func clear() -> void:
	path.clear()

func append(object: NavigationPoint) -> void:
	path.append(object)

func back() -> NavigationPoint:
	return path.back()

func before_back() -> NavigationPoint:
	return path[-2] if path.size() >= 2 else  null

func pop() -> NavigationPoint:
	return path.pop_front()

func get_next() -> NavigationPoint:
	if path.is_empty(): return null
	return path.front()

func create_copy() -> Path:
	var new_path: Path = Path.new()
	for point in path:
		new_path.append(point)
	return new_path
