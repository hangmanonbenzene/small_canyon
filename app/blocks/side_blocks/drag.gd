extends MeshInstance3D

var base_color: Color = Color.SADDLE_BROWN
var material: Material

var is_pressed: bool
var screen_pos: Vector2

@export var sideblock: SideBlock

func _ready() -> void:
	material = StandardMaterial3D.new()
	material.albedo_color = base_color
	material_override = material

func _on_mouse_entered() -> void:
	material.albedo_color = Color.SANDY_BROWN


func _on_mouse_exited() -> void:
	material.albedo_color = base_color


func _on_area_3d_2_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		is_pressed = true
		screen_pos = camera.unproject_position(event_position)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.pressed and event.button_index == 1:
		if is_pressed:
			is_pressed = false

func _process(_delta: float) -> void:
	if is_pressed:
		var new_position: Vector2 = get_viewport().get_mouse_position()
		var mouse_delta := new_position - screen_pos
		var block: Block = sideblock.block
		var conf: MoveConfig = block.move_config
		var other_blocks: Array[Block] = conf.blocks
		var move_x: float = mouse_delta.x * 0.01
		var move_y: float = mouse_delta.y * 0.01
		
		if conf.xyz == 0:
			for other_block in other_blocks:
				other_block.global_position.x += move_x
		elif conf.xyz == 1:
			for other_block in other_blocks:
				other_block.global_position.y += move_y
		elif conf.xyz == 2:
			for other_block in other_blocks:
				other_block.global_position.z -= move_x
		
		screen_pos = new_position
