class_name MyEnvirement extends Node3D

@export var camera: Camera3D
@export var camera_control: CharacterBody3D
var speed: float = 5.0
enum {DISABLED, MODE2D, MODE3D}
var mode: int = DISABLED:
	set(value):
		match value:
			DISABLED:
				mode = value
				reset_camera()
			MODE2D:
				mode = value
				reset_camera()
			MODE3D:
				mode = value
				camera.projection = Camera3D.PROJECTION_PERSPECTIVE

func _ready() -> void:
	reset_camera()

func reset_camera() -> void:
	camera_control.rotation_degrees = Vector3(-35.26438968, 45, 0)
	camera_control.global_position = Vector3i(10, 10, 10)
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL

func _physics_process(_delta: float) -> void:
	if mode == MODE2D:
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
			camera_control.velocity = velocity.normalized() * speed
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
			camera_control.velocity = velocity.normalized() * speed
			camera_control.move_and_slide()
