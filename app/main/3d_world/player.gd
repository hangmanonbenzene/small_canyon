class_name Player extends Node3D

var standing_on: NavigationField
@export var starting_on: NavigationField

func reset() -> void:
	position = Vector3.ZERO
	rotation_degrees = Vector3.ZERO
	standing_on = starting_on
