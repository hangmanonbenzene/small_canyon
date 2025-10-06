extends Node

var normal_cam: bool = true
@export var cam1: Camera3D
@export var cam2: Camera3D

func _input(event) -> void:
	if event.is_action_pressed("toggle_cam"):
		switch()

func switch():
	if normal_cam:
		normal_cam = false
		cam1.current = false
		cam2.current = true
	else:
		normal_cam = true
		cam1.current = true
		cam2.current = false
