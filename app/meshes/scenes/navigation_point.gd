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
@export var up_point: Node3D
@export var center: Node3D

func get_connections() -> Array[NavigationPoint]:
	if middle:
		return edge_connections
	else:
		var connections: Array[NavigationPoint] = []
		connections.append(middle_connection)
		
		var dir: Vector3i = (coordinates.global_position - direction_point.global_position).normalized()
		var up: Vector3i = -((up_point.global_position - center.global_position).normalized())
		var inverse_correction: Vector3i = up if inverse else Vector3i.ZERO
		
		var next_block: ConnectionPoint = field.side_block.block.world3d.connection_points.get(Main.get_position(center) + dir - up + inverse_correction)
		var mask: int = 4
		if next_block == null:
			var _debug: Vector3i = Main.get_position(center) + dir + inverse_correction
			next_block = field.side_block.block.world3d.connection_points.get(Main.get_position(center) + dir + inverse_correction)
			mask = 2
			up = -up
			if next_block == null:
				next_block = field.side_block.block.world3d.connection_points.get(Main.get_position(center) + inverse_correction)
				mask = 8
		
		var connection: NavigationPoint = get_connection(next_block, up, dir, mask)
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
