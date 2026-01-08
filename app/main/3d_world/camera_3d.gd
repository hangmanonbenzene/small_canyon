class_name MyEnvirement extends Node3D

@export var mouse_sensitivity := 0.0025
@export var pitch_limit := 80.0
var yaw := 0.0
var pitch := 0.0

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
					camera_control.rotation_degrees = Vector3(0, 45, 0)
					camera.rotation_degrees = Vector3(-35.26438968, 0, 0)
					camera_control.global_position = Vector3i(10, 10, 10)
					camera.projection = Camera3D.PROJECTION_PERSPECTIVE
				mode = value
			PLAY:
				mode = value
				camera.size = 15
				reset_camera()
			PAUSE2D:
				mode = value
			PAUSE3D:
				mode = value

func _ready() -> void:
	reset_camera()

func reset_camera() -> void:
	camera_control.rotation_degrees = Vector3(-35.26438968, 45, 0)
	camera.rotation_degrees = Vector3.ZERO
	camera_control.global_position = Vector3i(100, 100, 100)
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

var target: Node3D
var follow_speed := 5.0

func _process(delta: float) -> void:
	if not target:
		return
	
	# Convert target position into camera-local space
	var local_target_pos: Vector3 = camera_control.global_transform.affine_inverse() * target.global_transform.origin

	# We only care about X and Y (camera space)
	var local_offset: Vector3 = Vector3(
		local_target_pos.x,
		local_target_pos.y,
		0.0
	)

	# Convert back to world space
	var desired_global_pos: Vector3 = camera_control.global_transform * local_offset

	# Smooth follow
	camera_control.global_transform.origin = camera_control.global_transform.origin.lerp(
		desired_global_pos,
		follow_speed * delta
	)

func _unhandled_input(event: InputEvent) -> void:
	if mode == MODE3D and event is InputEventMouseMotion:
		# apply raw delta * sensitivity
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		
		# clamp vertical
		pitch = clamp(pitch, deg_to_rad(-pitch_limit), deg_to_rad(pitch_limit))
		
		camera_control.rotation.y = yaw
		camera.rotation.x = pitch
