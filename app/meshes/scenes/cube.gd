extends MeshInstance3D

@export var col2: Area3D

func activate(act: bool) -> void:
	if act:
		col2.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		col2.process_mode = Node.PROCESS_MODE_DISABLED
	visible = act
