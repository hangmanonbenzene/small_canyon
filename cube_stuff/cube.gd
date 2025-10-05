@tool
extends Node3D

@export var enable_one: bool = true:
	set(value):
		enable_one = value
		changed_one(value)
@export var enable_two: bool = true:
	set(value):
		enable_two = value
		changed_two(value)
@export var enable_three: bool = true:
	set(value):
		enable_three = value
		changed_three(value)
@export var enable_four: bool = true:
	set(value):
		enable_four = value
		changed_four(value)
@export var enable_five: bool = true:
	set(value):
		enable_five = value
		changed_five(value)
@export var enable_six: bool = true:
	set(value):
		enable_six = value
		changed_six(value)

@export var side_one: Node3D
@export var side_two: Node3D
@export var side_three: Node3D
@export var side_four: Node3D
@export var side_five: Node3D
@export var side_six: Node3D

@export var side_one_one: Node3D
@export var side_one_two: Node3D
@export var side_one_three: Node3D
@export var side_one_four: Node3D
@export var side_two_one: Node3D
@export var side_two_two: Node3D
@export var side_two_three: Node3D
@export var side_two_four: Node3D
@export var side_three_one: Node3D
@export var side_three_two: Node3D
@export var side_three_three: Node3D
@export var side_three_four: Node3D
@export var side_four_one: Node3D
@export var side_four_two: Node3D
@export var side_four_three: Node3D
@export var side_four_four: Node3D
@export var side_five_one: Node3D
@export var side_five_two: Node3D
@export var side_five_three: Node3D
@export var side_five_four: Node3D
@export var side_six_one: Node3D
@export var side_six_two: Node3D
@export var side_six_three: Node3D
@export var side_six_four: Node3D

func changed_one(value):
	side_one.visible = value
func changed_two(value):
	side_two.visible = value
func changed_three(value):
	side_three.visible = value
func changed_four(value):
	side_four.visible = value
func changed_five(value):
	side_five.visible = value
func changed_six(value):
	side_six.visible = value
