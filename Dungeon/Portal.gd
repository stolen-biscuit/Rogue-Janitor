extends Spatial

var is_active = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func activate_portal():
	is_active = true
	$Particles.emitting = true

func check_if_portal_should_activate():
	var activate = true
	#print(DungeonData.items_cleared["bodies"], DungeonData.item_totals["bodies"])
	#print(DungeonData.items_cleared["junk"], DungeonData.item_totals["junk"])
	#print(DungeonData.items_cleared["blood"], DungeonData.item_totals["blood"])
	#print(DungeonData.items_cleared["chests"], DungeonData.item_totals["chests"])
	
	if DungeonData.items_cleared["bodies"] < DungeonData.item_totals["bodies"]:
		activate = false
	if DungeonData.items_cleared["junk"] < DungeonData.item_totals["junk"]:
		activate = false
	if DungeonData.items_cleared["blood"] < DungeonData.item_totals["blood"]:
		activate = false
	if DungeonData.items_cleared["chests"] < DungeonData.item_totals["chests"]:
		activate = false
	return activate

func _process(delta):
	if !is_active:
		if check_if_portal_should_activate():
			print("Activate portal")
			activate_portal()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func disable_portal():
	is_active = false
	$Particles.emitting = false
	$portal.queue_free()

func _on_portal_area_entered(area):
	print(is_active)
	if is_active:
		#DungeonData.reset_counter()
		get_tree().change_scene_to(load("res://menu/inbetween_levels.tscn"))
