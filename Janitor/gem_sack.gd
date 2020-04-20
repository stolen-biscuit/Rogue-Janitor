extends "res://Dungeon/dungeon_item.gd"

func is_pickable(body):
	if body.is_in_group("pickable"):
		return true
	return false

func grab():
	held = true
	
func drop(_i):
	held = false

func move_item(new_pos, part):
	#part.global_transform.origin = new_pos
	var sack_pos = new_pos
	sack_pos.y = 0.3 #$head.global_transform.origin.y
	for node in get_children():
		if node is StaticBody:
			node.global_transform.origin = sack_pos
	$sack_opening.global_transform.origin.y += 0.05
	$gem_spawner.global_transform.origin.y += 0.05


func _ready():
	pass # Replace with function body.

