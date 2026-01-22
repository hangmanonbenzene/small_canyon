class_name MoveConfig

var xyz: int = 0
var pos: int = 0
var neg: int = 0

var blocks: Array[Block]

func get_data() -> String:
	var ids: Array[int]
	for block in blocks:
		if block != null:
			ids.append(block.block_id)
	if ids.is_empty(): return ""
	var data_dict: Dictionary = {
		"xyz" : xyz,
		"pos" : pos,
		"neg" : neg,
		"ids" : ids
	}
	return JSON.stringify(data_dict)
