class_name MyEnvirement extends Node3D

@export var camera: Camera3D
@export var camera_control: CharacterBody3D
var speed2d: float = 1.0
var speed3d: float = 5.0
var camera_size_2d: float = 7.0
enum {DISABLED, MODE2D, MODE3D, PLAY, PAUSE2D, PAUSE3D}
var mode: int = DISABLED:
	set(value):
		match value:
			DISABLED:
				mode = value
				camera.size = 7
				reset_camera()
			MODE2D:
				if mode != PAUSE2D:
					camera.size = camera_size_2d
					reset_camera()
				mode = value
			MODE3D:
				if mode != PAUSE3D:
					camera.size = 7
					camera.projection = Camera3D.PROJECTION_PERSPECTIVE
				mode = value
			PLAY:
				mode = value
				camera.size = 7
				reset_camera()
			PAUSE2D:
				mode = value
			PAUSE3D:
				mode = value

func _ready() -> void:
	reset_camera()

func reset_camera() -> void:
	camera_control.rotation_degrees = Vector3(-35.26438968, 45, 0)
	camera_control.global_position = Vector3i(10, 10, 10)
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL

func _physics_process(_delta: float) -> void:
	if mode == MODE2D:
		if Input.is_action_just_pressed("zoom_in"):
			camera.size = max(5, camera.size - 1)
			camera_size_2d = camera.size
		if Input.is_action_just_pressed("zoom_out"):
			camera.size = min(25, camera.size + 1)
			camera_size_2d = camera.size
		var velocity: Vector3 = Vector3.ZERO
		if Input.is_action_pressed("move_forward"):
			velocity += camera_control.transform.basis.y
		if Input.is_action_pressed("move_backward"):
			velocity -= camera_control.transform.basis.y
		if Input.is_action_pressed("move_left"):
			velocity -= camera_control.transform.basis.x
		if Input.is_action_pressed("move_right"):
			velocity += camera_control.transform.basis.x
		if velocity.length() > 0:
			camera_control.velocity = velocity.normalized() * speed2d * camera_size_2d
			camera_control.move_and_slide()
	elif mode == MODE3D:
		var velocity: Vector3 = Vector3.ZERO
		if Input.is_action_pressed("move_forward"):
			velocity -= camera_control.transform.basis.z
		if Input.is_action_pressed("move_backward"):
			velocity += camera_control.transform.basis.z
		if Input.is_action_pressed("move_left"):
			velocity -= camera_control.transform.basis.x
		if Input.is_action_pressed("move_right"):
			velocity += camera_control.transform.basis.x
		if Input.is_action_pressed("move_up"):
			velocity += camera_control.transform.basis.y
		if Input.is_action_pressed("move_down"):
			velocity -= camera_control.transform.basis.y
		if velocity.length() > 0:
			camera_control.velocity = velocity.normalized() * speed3d
			camera_control.move_and_slide()
	elif mode == PLAY:
		pass
