class_name NavigationPoint extends Node3D

@export var coordinates: Node3D
@export var field: NavigationField

@export var middle: bool
@export var flat: bool
@export var inverse: bool
@export var flat_round: bool
@export var walk_inverse: bool

@export var middle_connection: NavigationPoint
@export var edge_connections: Array[NavigationPoint]
@export var rotation_point: Node3D
@export var direction_point: Node3D
@export var up_point: Node3D
@export var center: Node3D

func get_connections(from_middle: bool) -> Array[NavigationPoint]:
	if middle:
		return edge_connections
	else:
		var connections: Array[NavigationPoint] = []
		if not from_middle:
			connections.append(middle_connection)
			return connections
		
		var dir: Vector3i = (coordinates.global_position - direction_point.global_position).normalized()
		var towards: bool = dir == Vector3i.RIGHT or dir == Vector3i.UP or dir == Vector3i.BACK
		var up: Vector3i = (up_point.global_position - center.global_position).normalized()
		var in_front_of: bool = up == Vector3i.RIGHT or up == Vector3i.UP or up == Vector3i.BACK
		var inverse_correction: Vector3i = -up if inverse else Vector3i.ZERO
		var is_ladder: bool = field.side_block.type == World.LADDER
		
		var this_block_coordinates: Vector3i = Main.get_position(center) + inverse_correction
		var this_block_2D: Vector2i = Vector2i(this_block_coordinates.x - this_block_coordinates.z, 2 * this_block_coordinates.y - this_block_coordinates.x - this_block_coordinates.z)
		var front_block_coordinates: Vector3i = this_block_coordinates + dir
		var front_block_2D: Vector2i = Vector2i(front_block_coordinates.x - front_block_coordinates.z, 2 * front_block_coordinates.y - front_block_coordinates.x - front_block_coordinates.z)
		var up_block_coordinates: Vector3i = front_block_coordinates + up
		var up_block_2D: Vector2i = Vector2i(up_block_coordinates.x - up_block_coordinates.z, 2 * up_block_coordinates.y - up_block_coordinates.x - up_block_coordinates.z)
		
		var this_block: ConnectionPoint = field.side_block.block.world3d.connection_points.get(this_block_coordinates)
		var front_block: ConnectionPoint = field.side_block.block.world3d.connection_points.get(front_block_coordinates)
		var up_block: ConnectionPoint = field.side_block.block.world3d.connection_points.get(up_block_coordinates)
		var this_block_first: ConnectionPoint = field.side_block.block.world3d.map2d.get(this_block_2D)
		var front_block_first: ConnectionPoint = field.side_block.block.world3d.map2d.get(front_block_2D)
		var up_block_first: ConnectionPoint = field.side_block.block.world3d.map2d.get(up_block_2D)
		
		var current_block: ConnectionPoint = field.side_block.block.world3d.connection_points.get(Main.get_position(field.side_block.block))
		
		var try_front: bool
		var connection: NavigationPoint
		if towards:
			if up_block_first != null and up_block_first.block.base_color == current_block.block.base_color and up_block_first.depth > current_block.depth and (front_block_first == null or up_block_first.depth > front_block_first.depth): 
				connection = get_connection(up_block_first, -up, dir, 4)
			elif front_block_first != null and front_block_first.block.base_color == current_block.block.base_color and front_block_first.depth > current_block.depth and (up_block_first == null or up_block_first.block.base_color == current_block.block.base_color): 
				connection = get_connection(front_block_first, up, dir, 2)
				try_front = true
			elif up_block != null: 
				connection = get_connection(up_block, -up, dir, 4)
			elif front_block != null: 
				connection = get_connection(front_block, up, dir, 2)
				try_front = true
			else: 
				connection = get_connection(this_block, up, dir, 8)
		else:
			if up_block != null: 
				connection = get_connection(up_block, -up, dir, 4)
			elif front_block != null: 
				connection = get_connection(front_block, up, dir, 2)
				try_front = true
			elif up_block_first != null and up_block_first.block.base_color == current_block.block.base_color and up_block_first.depth < current_block.depth and (front_block_first == null or up_block_first.depth > front_block_first.depth): 
				connection = get_connection(up_block_first, -up, dir, 4)
			elif front_block_first != null and front_block_first.block.base_color == current_block.block.base_color and front_block_first.depth < current_block.depth and (up_block_first == null or up_block_first.block.base_color == current_block.block.base_color): 
				connection = get_connection(front_block_first, up, dir, 2)
				try_front = true
			else: 
				connection = get_connection(this_block, up, dir, 8)
		
		if connection == null and try_front: connection = get_connection(this_block, up, dir, 8)
		
		if connection != null: connections.append(connection)
		
		return connections

func get_connection(next_block: ConnectionPoint, up: Vector3i, dir: Vector3i, mask: int) -> NavigationPoint:
	if next_block != null:
		var dic1: Dictionary = Main.raycast(next_block, up, mask)
		var collider1: Area3D = dic1.get("collider")
		if collider1 != null:
			var dic2: Dictionary = Main.raycast(collider1.get_child(0), -dir, mask)
			var collider2: Area3D = dic2.get("collider")
			if collider2 != null:
				return collider2.get_child(0)
	return null

func _on_edge_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1: print("drgjhfgikfdjgdröl")
