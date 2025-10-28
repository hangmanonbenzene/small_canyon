extends Node3D

@export var sides: Array[MeshInstance3D]
@export var side_color: Color:
	set(value):
		sides[0].material_override.albedo_color = value
		side_color = value

var current_mode: bool
static var one_is_pressed: bool
var is_pressed: bool
var is_entered: bool
var current_camera: Camera3D

func _ready() -> void:
	var material: BaseMaterial3D = StandardMaterial3D.new()
	for side in sides:
		side.material_override = material

func _input(event: InputEvent) -> void:
	if current_mode:
		if event is InputEventMouseButton and not event.pressed and event.button_index == 1:
			if is_pressed:
				is_pressed = false
				one_is_pressed = false
				if not is_entered: side_color = Color.WHITE
			elif is_entered: 
				side_color = Color.ORANGE
		if is_pressed and event is InputEventMouseMotion:
			var mouse_vector: Vector2 = event.position - current_camera.unproject_position(global_position)
			print(mouse_vector.length())
			print(rad_to_deg(mouse_vector.angle()))

func _on_area_3d_input_event(camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if current_mode:
		if event is InputEventMouseButton and event.pressed and event.button_index == 1:
			is_pressed = true
			one_is_pressed = true
			current_camera = camera

func _on_area_3d_mouse_entered() -> void:
	if current_mode: 
		is_entered = true
		if not one_is_pressed:
			side_color = Color.ORANGE

func _on_area_3d_mouse_exited() -> void:
	if current_mode: 
		is_entered = false
		if not one_is_pressed:
			side_color = Color.WHITE

func change_mode(edit_mode: bool) -> void:
	current_mode = edit_mode
