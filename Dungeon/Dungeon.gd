extends Spatial

# Rooms are 5x5
var rooms = []
var room_generated = []
var room_scene = preload("res://Dungeon/Room.tscn")
var janitor_scene = preload("res://Janitor/Janitor.tscn")
var basket_scene = preload("res://Dungeon/basket.tscn")
var grue_box_scene = preload("res://Dungeon/grue_box.tscn")
var sponge_scene = preload("res://Janitor/sponge.tscn")
var gem_sack_scene = preload("res://Janitor/gem_sack.tscn")

func _ready():
	randomize()
	init_level()
	generate_level()
	find_portal()

func get_children_nodes_in_group(node, group, list):
	for child in node.get_children():
		if child.is_in_group("HUDLayer"):
			pass
		if child.get_child_count() > 0:
			get_children_nodes_in_group(child, group, list)
			if child.is_in_group(group):
				list.append(child)
		else:
			if child.is_in_group(group):
				list.append(child)
	return

func find_portal():
	var portal_list = []
	get_children_nodes_in_group(self, "portal", portal_list)
	$CanvasLayer/HUD.connect("game_over", portal_list[0], "disable_portal")
	print($CanvasLayer/HUD.get_signal_connection_list("game_over"))

func init_level():
	for x in range(0,4):
		rooms.append([])
		room_generated.append([])
		for y in range(0,4):
			rooms[x].append([])
			room_generated[x].append(false)
			rooms[x][y] = room_scene.instance()
			add_child(rooms[x][y])
			rooms[x][y].generate_room(-1, Vector2(x*10, y*10))
			room_generated[x][y] = false

func is_pickable(_body):
	return false
			
# Pick a random room on top row
	# Roll a random number between 0-4
	# if it's 0 or 1, set room as type1 and move left
	# if it's 2 or 3, set room as type 1 and move right
	# if it's 4, set it as type 2 and move down
	# if we hit a wall, move down and turn direction
	# if we try and move down on the bottom layer, place the collectible mantle
	
	# Once we're done, set all rooms we didn't touch as room type0, which is just
	# a dead end. Pick a random wall and make a door between it and the adjacent room
func generate_level():
	var mantle_placed = false
	var starting_pos = randi()%4
	var next_room_type
	var current_position = Vector2()
	var real_world_position = Vector2()
	var room_type
	
	# This gives us room type 3 if we want it
	var last_placed_went_down = false
	current_position = Vector2(starting_pos, 0)
	while !mantle_placed:
		next_room_type = randi()%5
		if next_room_type == 0 or next_room_type == 1:
			room_type = 1
			real_world_position = Vector2(current_position.x*10, current_position.y*10)
			rooms[current_position.x][current_position.y].generate_room(room_type, real_world_position)
			#add_child(rooms[current_position.x][current_position.y])
				
			last_placed_went_down = false
			room_generated[current_position.x][current_position.y] = true
			current_position.x -= 1	
		elif next_room_type == 2 or next_room_type == 3:
			room_type = 1
			real_world_position = Vector2(current_position.x*10, current_position.y*10)
			rooms[current_position.x][current_position.y].generate_room(room_type, real_world_position)
			room_generated[current_position.x][current_position.y] = true
			last_placed_went_down = false
			current_position.x += 1
		elif next_room_type == 4:
			room_type = 3
			real_world_position = Vector2(current_position.x*10, current_position.y*10)
			rooms[current_position.x][current_position.y].generate_room(room_type, real_world_position)
				#add_child(rooms[current_position.x][current_position.y])
				
			last_placed_went_down = true
			room_generated[current_position.x][current_position.y] = true
			current_position.y += 1
		
		
		if current_position.x < 0:
			current_position.x = 0
			#rooms[current_position.x][current_position.y].reset_walls()
			rooms[current_position.x][current_position.y].generate_room(3, real_world_position)
			#add_child(rooms[current_position.x][current_position.y])
			last_placed_went_down = true
			room_generated[current_position.x][current_position.y] = true
			current_position.y += 1
		if current_position.x > 3:
			current_position.x = 3
			#rooms[current_position.x][current_position.y].reset_walls()
			rooms[current_position.x][current_position.y].generate_room(3, real_world_position)
			last_placed_went_down = true
			room_generated[current_position.x][current_position.y] = true
			current_position.y += 1
		
			
		if current_position.y > 3:
			current_position.y = 3
			real_world_position = Vector2(current_position.x*10, current_position.y*10)
			rooms[current_position.x][current_position.y].reset_walls()
			rooms[current_position.x][current_position.y].generate_room(1, real_world_position)
			#add_child(rooms[current_position.x][current_position.y])
			rooms[current_position.x][current_position.y].place_portal()
			mantle_placed = true
			
		if last_placed_went_down:
			rooms[current_position.x][current_position.y].open_wall("up")
			last_placed_went_down = false
	
	
	# Iterate through rooms
	# Find all -1 type rooms
	# Find all neighbour cell types
	# If any have doors pointing to them
	# Open those doors
	for x in range(0,4):
		for y in range(0,4):
			if rooms[x][y].get_room_type() == -1:
				rooms[x][y].queue_free()
				rooms[x][y] = null
				
	for x in range(0,4):
		for y in range(0,4):
			if rooms[x][y] != null:
				real_world_position = Vector2(x*10, y*10)
				if x != 0:
					if rooms[x-1][y] == null:
						rooms[x][y].close_wall("right")
				if x != 3:
					if rooms[x+1][y] == null:
						rooms[x][y].close_wall("left")
				if y != 0:
					if rooms[x][y-1] == null:
						rooms[x][y].close_wall("up")
				if y != 3:
					if rooms[x][y+1] == null:
						rooms[x][y].close_wall("down")
				rooms[x][y].delete_hidden_walls()
				rooms[x][y].generate_room_objects()
		
	for x in range(0, 4):
		if rooms[x][0] != null:
			var grue_box = grue_box_scene.instance()
			var janitor = janitor_scene.instance()
			var sponge = sponge_scene.instance()
			var gem_sack = gem_sack_scene.instance()
			
			janitor.translation.x = (x*10)
			janitor.translation.z = 0
			janitor.translation.y += 2
			grue_box.translation.x = (x*10)+2
			grue_box.translation.z = 1
			grue_box.translation.y += 0.2
			sponge.translation.x = (x*10)+3
			sponge.translation.z = 2
			sponge.translation.y = 0
			gem_sack.translation.x = (x*10)+3
			gem_sack.translation.z = 3
			gem_sack.translation.y += 0.2
			$CanvasLayer/HUD.update_totals()
			add_child(grue_box)
			add_child(janitor)
			add_child(sponge)
			add_child(gem_sack)
			break
