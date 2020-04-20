extends Spatial

var portal = preload("res://Dungeon/Portal.tscn")
var junk = preload("res://Dungeon/Junk.tscn")
var chest = preload("res://Dungeon/Chest.tscn")
var blood = preload("res://Dungeon/Blood.tscn")
var body = preload("res://Dungeon/Body.tscn")

enum Type {
	Uninitialized = -1,
	DeadEnd = 0,
	Left_Right = 1,
	Left_Right_Up = 2,
	Left_Right_Down = 3
}

var room_type = -1

func _ready():
	room_type = Type.Uninitialized
	
func get_room_type():
	return room_type

func place_portal():
	var new_portal = portal.instance()
	new_portal.translation.x = 0
	new_portal.translation.z = 0
	add_child(new_portal)

func generate_room(type, position: Vector2, door_pos = null):
	translation.x = position.x
	translation.z = position.y
	var dungeon_x = position.x/10
	var dungeon_y = position.y/10
	room_type = type
	if type == 0:
		if door_pos == "right":
			$walls/east_wall/Wall3.hide()
		if door_pos == "left":
			$walls/west_wall/Wall3.hide()
		if door_pos == "up":
			$walls/north_wall/Wall3.hide()
		if door_pos == "down":
			$walls/south_wall/Wall3.hide()
	elif type == 1:
		# Place left right
		if dungeon_x != 0:
			$walls/west_wall/Wall3.hide()
		if dungeon_x != 3:
			$walls/east_wall/Wall3.hide()
	elif type == 2:
		# Place left/right/down
		if dungeon_x != 0:
			$walls/west_wall/Wall3.hide()
		if dungeon_x != 3:
			$walls/east_wall/Wall3.hide()
		if dungeon_y != 0:
			$walls/north_wall/Wall3.hide()
	elif type == 3:
		# Place left right up
		if dungeon_x != 0:
			$walls/west_wall/Wall3.hide()
		if dungeon_x != 3:
			$walls/east_wall/Wall3.hide()
		if dungeon_y != 3:
			$walls/south_wall/Wall3.hide()
		#if dungeon_y != 3:
		#	$walls/south_wall/Wall3.hide()
	
	#delete_hidden_walls(position)

func delete_hidden_walls():
	if !$walls/east_wall/Wall3.is_visible_in_tree():
		$walls/east_wall/Wall3.free()
	if !$walls/west_wall/Wall3.is_visible_in_tree():
		$walls/west_wall/Wall3.free()
	if !$walls/north_wall/Wall3.is_visible_in_tree():
		$walls/north_wall/Wall3.free()
	if !$walls/south_wall/Wall3.is_visible_in_tree():
		$walls/south_wall/Wall3.free()

func reset_walls():
	$walls/east_wall/Wall3.show()
	$walls/west_wall/Wall3.show()	
	$walls/north_wall/Wall3.show()
	$walls/south_wall/Wall3.show()

func open_wall(side):
	if side == "left":
		$walls/east_wall/Wall3.hide()
	elif side == "right":
		$walls/west_wall/Wall3.hide()
	elif side == "up":
		$walls/north_wall/Wall3.hide()
	elif side == "down":
		$walls/south_wall/Wall3.hide()

func close_wall(side):
	if side == "left":
		$walls/east_wall/Wall3.show()
	elif side == "right":
		$walls/west_wall/Wall3.show()
	elif side == "up":
		$walls/north_wall/Wall3.show()
	elif side == "down":
		$walls/south_wall/Wall3.show()

func generate_room_objects(difficulty = 15, amount = 5):
	for i in randi()%amount+1:
		var placement_value = randi()%difficulty
		var randx = randi()%4+1
		var randz = randi()%4+1
		var rand_rot = randi()%360
		var rand_scale = randf() + 0.3
		if placement_value == 1 or placement_value == 2:
			var new_blood = blood.instance()
			new_blood.translation.x = randx
			new_blood.translation.z = randz
			new_blood.translation.y = 0.2
			new_blood.scale.x = rand_scale
			new_blood.scale.z = rand_scale
			new_blood.rotate_y(rand_rot)
			add_child(new_blood)
			DungeonData.item_totals["blood"] += 1
		elif placement_value == 4:
			var new_body = body.instance()
			var new_blood = blood.instance()
			new_body.translation.x = randx
			new_body.translation.z = randz
			new_body.translation.y = 1
			new_body.rotate_y(rand_rot)
			new_blood.translation.x = randx
			new_blood.translation.z = randz
			new_blood.translation.y = 0.2
			new_blood.rotate_y(rand_rot)
			new_blood.scale.x = rand_scale
			new_blood.scale.z = rand_scale
			add_child(new_body)
			DungeonData.item_totals["bodies"] += 1
			add_child(new_blood)
			DungeonData.item_totals["blood"] += 1
		elif placement_value == 5 or placement_value == 6:
			var new_junk = junk.instance()
			new_junk.translation.x = randx
			new_junk.translation.z = randz
			new_junk.translation.y = 0.2
			new_junk.rotate_y(rand_rot)
			add_child(new_junk)
			DungeonData.item_totals["junk"] += 1
		elif placement_value == 7:
			var new_chest = chest.instance()
			new_chest.translation.x = randi()%3
			new_chest.translation.z = randi()%3
			print("Chest Position")
			print(new_chest.translation)
			#if randx < 4:
			#	new_chest.translation.x = randx+3
			#elif randx > 8:	
			#	new_chest.translation.x = randx-3
			#if randz < 4:
			#	new_chest.translation.z = randz+3
			#elif randz > 8:	
			#	new_chest.translation.z = randz-3	
			new_chest.translation.y = 0.2
			new_chest.rotate_y(rand_rot)
			add_child(new_chest)
			DungeonData.item_totals["chests"] += 1
	
