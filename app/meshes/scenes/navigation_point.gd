class_name NavigationPoint extends Node3D

@export var coordinates: Node3D
@export var field: NavigationField

@export var middle: bool
@export var flat: bool
@export var inverse: bool

@export var middle_connection: NavigationPoint
@export var edge_connections: Array[NavigationPoint]
@export var rotation_point: Node3D
@export var direction_point: Node3D

func get_connections() -> Array[NavigationPoint]:
	if middle:
		return edge_connections
	else:
		var connections: Array[NavigationPoint] = []
		connections.append(middle_connection)
		
		var dir: Vector3i = (coordinates.global_position - direction_point.global_position).normalized()
		var up: Vector3i = (direction_point.global_position - field.side_block.block.global_position).normalized()
		var next_block_coordinates: Vector3i = Main.get_position(field.side_block.block) + dir
		var next_block: ConnectionPoint = field.side_block.block.world3d.connection_points.get(next_block_coordinates)
		if next_block != null:
			var collider1: Area3D = Main.raycast(next_block, up, 2).get("collider")
			if collider1 != null:
				var dic: Dictionary = Main.raycast(collider1.get_child(0), -dir, 2)
				var collider2: Area3D = dic.get("collider")
				if collider2 != null:
					connections.append(collider2.get_child(dic.get("shape")))
		return connections
