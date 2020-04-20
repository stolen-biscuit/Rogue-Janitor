extends Spatial

var held = false
signal eaten
var body_parts = {
	head = false,
	chest = false,
	right_arm = false,
	left_arm = false,
	right_leg = false,
	left_leg = false
}
# = Item_Type.Yeet
enum Item_Type {
	Yeet,
	Junk,
	Body,
	Chest,
	Loot,
	Blood
}

var has_been_eaten

export (Item_Type) var item_type

func move_item(new_pos, part):
	#part.global_transform.origin = new_pos
	for node in get_children():
		if node is RigidBody:
			node.global_transform.origin = new_pos# - self.global_transform.origin

func is_pickable(_body):
	if item_type == Item_Type.Blood:
		return false
	return true

func check_if_eaten():
	var eaten = true
	for part in body_parts.keys():
		if body_parts[part] == false:
			eaten = false
	return true

func eat_part(part):
	emit_signal("eaten")
	if item_type == Item_Type.Body:
		body_parts[part.name] = true
		
		if check_if_eaten():
			queue_free()
			DungeonData.items_cleared["bodies"] += 1
			DungeonData.score += 75
		else:
			part.queue_free()
	else:
		has_been_eaten = true
		DungeonData.items_cleared["junk"] += 1
		queue_free()
		DungeonData.score += 25
	
	return
	
func grab():
	held = true
	for node in get_children():
		if node is RigidBody:
			node.set_mode(RigidBody.MODE_CHARACTER)
	
func drop(impulse):
	held = false
	for node in get_children():
		if node is RigidBody:
			node.set_mode(RigidBody.MODE_RIGID)
			node.apply_central_impulse(impulse)


