extends Node

@export var menus: Node

func _ready() -> void:
	menus.call("load_levels")
