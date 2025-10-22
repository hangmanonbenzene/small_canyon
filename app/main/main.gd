extends Node

@export var world_3d: Node
@export var menus: Node

func _ready() -> void:
	menus.call("load_levels")
