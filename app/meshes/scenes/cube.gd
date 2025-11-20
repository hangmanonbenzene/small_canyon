class_name CubeSide extends SideBlock

@export var col1: Area3D
@export var col2: Area3D

func activate(act: bool) -> void:
	if act:
		col1.process_mode = Node.PROCESS_MODE_INHERIT
		col2.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		col1.process_mode = Node.PROCESS_MODE_DISABLED
		col2.process_mode = Node.PROCESS_MODE_DISABLED
	visible = act
