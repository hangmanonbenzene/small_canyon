@tool
extends Node3D

@export_group("Sides")
@export var enable_one: bool = true:
	set(value):
		enable_one = value
		$"Side 1".visible = value
@export var enable_two: bool = true:
	set(value):
		enable_two = value
		$"Side 2".visible = value
@export var enable_three: bool = true:
	set(value):
		enable_three = value
		$"Side 3".visible = value
@export var enable_four: bool = true:
	set(value):
		enable_four = value
		$"Side 4".visible = value
@export var enable_five: bool = true:
	set(value):
		enable_five = value
		$"Side 5".visible = value
@export var enable_six: bool = true:
	set(value):
		enable_six = value
		$"Side 6".visible = value

@export_group("Subsides")
@export var enable_one_one: bool = true:
	set(value):
		enable_one_one = value
		$"Side 1/MeshInstance3D".visible = value
@export var enable_one_two: bool = true:
	set(value):
		enable_one_two = value
		$"Side 1/MeshInstance3D2".visible = value
@export var enable_one_three: bool = true:
	set(value):
		enable_one_three = value
		$"Side 1/MeshInstance3D3".visible = value
@export var enable_one_four: bool = true:
	set(value):
		enable_one_four = value
		$"Side 1/MeshInstance3D4".visible = value
@export var enable_two_one: bool = true:
	set(value):
		enable_two_one = value
		$"Side 2/MeshInstance3D".visible = value
@export var enable_two_two: bool = true:
	set(value):
		enable_two_two = value
		$"Side 2/MeshInstance3D2".visible = value
@export var enable_two_three: bool = true:
	set(value):
		enable_two_three = value
		$"Side 2/MeshInstance3D3".visible = value
@export var enable_two_four: bool = true:
	set(value):
		enable_two_four = value
		$"Side 2/MeshInstance3D4".visible = value
@export var enable_three_one: bool = true:
	set(value):
		enable_three_one = value
		$"Side 3/MeshInstance3D".visible = value
@export var enable_three_two: bool = true:
	set(value):
		enable_three_two = value
		$"Side 3/MeshInstance3D2".visible = value
@export var enable_three_three: bool = true:
	set(value):
		enable_three_three = value
		$"Side 3/MeshInstance3D3".visible = value
@export var enable_three_four: bool = true:
	set(value):
		enable_three_four = value
		$"Side 3/MeshInstance3D4".visible = value
@export var enable_four_one: bool = true:
	set(value):
		enable_four_one = value
		$"Side 4/MeshInstance3D".visible = value
@export var enable_four_two: bool = true:
	set(value):
		enable_four_two = value
		$"Side 4/MeshInstance3D2".visible = value
@export var enable_four_three: bool = true:
	set(value):
		enable_four_three = value
		$"Side 4/MeshInstance3D3".visible = value
@export var enable_four_four: bool = true:
	set(value):
		enable_four_four = value
		$"Side 4/MeshInstance3D4".visible = value
@export var enable_five_one: bool = true:
	set(value):
		enable_five_one = value
		$"Side 5/MeshInstance3D".visible = value
@export var enable_five_two: bool = true:
	set(value):
		enable_five_two = value
		$"Side 5/MeshInstance3D2".visible = value
@export var enable_five_three: bool = true:
	set(value):
		enable_five_three = value
		$"Side 5/MeshInstance3D3".visible = value
@export var enable_five_four: bool = true:
	set(value):
		enable_five_four = value
		$"Side 5/MeshInstance3D4".visible = value
@export var enable_six_one: bool = true:
	set(value):
		enable_six_one = value
		$"Side 6/MeshInstance3D".visible = value
@export var enable_six_two: bool = true:
	set(value):
		enable_six_two = value
		$"Side 6/MeshInstance3D2".visible = value
@export var enable_six_three: bool = true:
	set(value):
		enable_six_three = value
		$"Side 6/MeshInstance3D3".visible = value
@export var enable_six_four: bool = true:
	set(value):
		enable_six_four = value
		$"Side 6/MeshInstance3D4".visible = value
