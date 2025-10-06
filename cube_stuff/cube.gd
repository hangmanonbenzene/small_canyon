@tool
extends Node3D

@export_group("Sides")
@export var enable_one: bool = true:
	set(value):
		enable_one = value
		side_one.visible = value
@export var enable_two: bool = true:
	set(value):
		enable_two = value
		side_two.visible = value
@export var enable_three: bool = true:
	set(value):
		enable_three = value
		side_three.visible = value
@export var enable_four: bool = true:
	set(value):
		enable_four = value
		side_four.visible = value
@export var enable_five: bool = true:
	set(value):
		enable_five = value
		side_five.visible = value
@export var enable_six: bool = true:
	set(value):
		enable_six = value
		side_six.visible = value

@export_group("Subsides")
@export var enable_one_one: bool = true:
	set(value):
		enable_one_one = value
		side_one_one.visible = value
@export var enable_one_two: bool = true:
	set(value):
		enable_one_two = value
		side_one_two.visible = value
@export var enable_one_three: bool = true:
	set(value):
		enable_one_three = value
		side_one_three.visible = value
@export var enable_one_four: bool = true:
	set(value):
		enable_one_four = value
		side_one_four.visible = value
@export var enable_two_one: bool = true:
	set(value):
		enable_two_one = value
		side_two_one.visible = value
@export var enable_two_two: bool = true:
	set(value):
		enable_two_two = value
		side_two_two.visible = value
@export var enable_two_three: bool = true:
	set(value):
		enable_two_three = value
		side_two_three.visible = value
@export var enable_two_four: bool = true:
	set(value):
		enable_two_four = value
		side_two_four.visible = value
@export var enable_three_one: bool = true:
	set(value):
		enable_three_one = value
		side_three_one.visible = value
@export var enable_three_two: bool = true:
	set(value):
		enable_three_two = value
		side_three_two.visible = value
@export var enable_three_three: bool = true:
	set(value):
		enable_three_three = value
		side_three_three.visible = value
@export var enable_three_four: bool = true:
	set(value):
		enable_three_four = value
		side_three_four.visible = value
@export var enable_four_one: bool = true:
	set(value):
		enable_four_one = value
		side_four_one.visible = value
@export var enable_four_two: bool = true:
	set(value):
		enable_four_two = value
		side_four_two.visible = value
@export var enable_four_three: bool = true:
	set(value):
		enable_four_three = value
		side_four_three.visible = value
@export var enable_four_four: bool = true:
	set(value):
		enable_four_four = value
		side_four_four.visible = value
@export var enable_five_one: bool = true:
	set(value):
		enable_five_one = value
		side_five_one.visible = value
@export var enable_five_two: bool = true:
	set(value):
		enable_five_two = value
		side_five_two.visible = value
@export var enable_five_three: bool = true:
	set(value):
		enable_five_three = value
		side_five_three.visible = value
@export var enable_five_four: bool = true:
	set(value):
		enable_five_four = value
		side_five_four.visible = value
@export var enable_six_one: bool = true:
	set(value):
		enable_six_one = value
		side_six_one.visible = value
@export var enable_six_two: bool = true:
	set(value):
		enable_six_two = value
		side_six_two.visible = value
@export var enable_six_three: bool = true:
	set(value):
		enable_six_three = value
		side_six_three.visible = value
@export var enable_six_four: bool = true:
	set(value):
		enable_six_four = value
		side_six_four.visible = value

@export_group("Nodes")
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
