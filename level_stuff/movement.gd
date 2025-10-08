extends Node

# Adjustable properties
@export var time: float = 0.3

@export var point_a: Vector3
@export var point_b: Vector3
@export var point_c: Vector3
@export var point_d: Vector3
@export var point_e: Vector3
@export var point_f: Vector3
@export var point_g: Vector3
@export var point_h: Vector3
@export var point_i: Vector3
@export var point_j: Vector3
@export var point_k: Vector3
@export var point_l: Vector3
@export var point_m: Vector3

@export var player1: Node3D
@export var player2: Node3D
@export var player3: Node3D

var a: bool = true
var b: bool = true
var c: bool = true

func _ready():
	while true:
		move_player_one_a()
		move_player_two_a()
		move_player_three_a()
		while not (a and b and c):
			await get_tree().create_timer(0.5).timeout
		await get_tree().create_timer(0.5).timeout
		move_player_one_b()
		move_player_two_b()
		move_player_three_b()
		while not (a and b and c):
			await get_tree().create_timer(0.5).timeout
		await get_tree().create_timer(0.5).timeout

func move_player_one_a():
	a = false
	await move_to_point(player1, point_b, 5)
	player1.priority = 1
	await move_to_point(player1, point_c, 3)
	await move_to_point(player1, point_d, 1)
	await move_to_point(player1, point_e, 2)
	a = true
func move_player_one_b():
	a = false
	await move_to_point(player1, point_d, 2)
	await move_to_point(player1, point_c, 1)
	await move_to_point(player1, point_b, 3)
	player1.priority = 0
	await move_to_point(player1, point_a, 5)
	a = true

func move_player_two_a():
	b = false
	await move_to_point(player2, point_g, 5)
	await move_to_point(player2, point_h, 6)
	b = true
func move_player_two_b():
	b = false
	await move_to_point(player2, point_g, 6)
	await move_to_point(player2, point_f, 5)
	b = true

func move_player_three_a():
	c = false
	await move_to_point(player3, point_j, 1)
	player3.priority = 1
	await move_to_point(player3, point_k, 2)
	player3.priority = 0
	await move_to_point(player3, point_l, 2)
	await move_to_point(player3, point_m, 6)
	c = true
func move_player_three_b():
	c = false
	await move_to_point(player3, point_l, 6)
	await move_to_point(player3, point_k, 2)
	player3.priority = 1
	await move_to_point(player3, point_j, 2)
	player3.priority = 0
	await move_to_point(player3, point_i, 1)
	c = true

# Helper function for smooth movement
func move_to_point(player: Node3D, target: Vector3, tiles: float) -> Signal:
	var duration = tiles * time
	var start = player.global_position
	var time_passed = 0.0

	while time_passed < duration:
		var t = time_passed / duration
		player.global_position = start.lerp(target, t)
		await get_tree().process_frame
		time_passed += get_process_delta_time()

	player.global_position = target
	return Signal()
