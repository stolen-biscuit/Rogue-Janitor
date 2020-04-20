extends "res://Dungeon/dungeon_item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func is_pickable(body):
	if body.name == "pole":
		return true
	return false

func grab():
	held = true
	
func drop(impulse):
	held = false


	
func move_item(new_pos, part):
	#part.global_transform.origin = new_pos
	var head_pos = new_pos
	head_pos.y = 0.2 #$head.global_transform.origin.y
	$pole.global_transform.origin = head_pos
	$head.global_transform.origin = head_pos

