extends Node

# Adjustable properties
@export var time: float = 0.3

@export var point_a: Vector3
@export var point_b: Vector3
@export var point_c: Vector3
@export var point_d: Vector3
@export var point_e: Vector3

@export var player: Node3D

func _ready():
	# Start the movement sequence when the scene is ready
	start_movement()

func start_movement():
	player.global_position = point_a
	while(true):
		await move_to_point(point_b, 5)
		player.priority = 1
		await move_to_point(point_c, 3)
		await move_to_point(point_d, 1)
		await move_to_point(point_e, 2)
		await move_to_point(point_d, 2)
		await move_to_point(point_c, 1)
		await move_to_point(point_b, 3)
		player.priority = 0
		await move_to_point(point_a, 5)

# Helper function for smooth movement
func move_to_point(target: Vector3, tiles: float) -> Signal:
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
