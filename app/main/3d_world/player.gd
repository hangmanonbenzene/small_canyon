class_name Player extends Node3D

@export var standing_on: NavigationField
@export var starting_on: NavigationField
@export var going_to: NavigationPoint
@export var coming_from: NavigationPoint

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

func _process(_delta: float) -> void:
	if not path.is_empty():
		print(path.pop())
