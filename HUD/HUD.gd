extends Control
signal game_over

func _ready():
	$Panel2/rows/timer/Label.text = "TIME REMAINING: "
	$timer.start(DungeonData.time_limit)
	$timer.one_shot = true
	$timer.connect("timeout", self, "game_over")


# Called when the node enters the scene tree for the first time.
func update_totals():
	$Panel/rows/blood_row/blood_total.add_color_override("font_color", Color(1,0,0,1))
	$Panel/rows/blood_row/blood_total.text = str(DungeonData.item_totals["blood"])

	$Panel/rows/body_row/body_total.add_color_override("font_color", Color(1,0,0,1))
	$Panel/rows/body_row/body_total.text = str(DungeonData.item_totals["bodies"])
	$Panel/rows/junk_row/junk_total.add_color_override("font_color", Color(1,0,0,1))
	$Panel/rows/junk_row/junk_total.text = str(DungeonData.item_totals["junk"])
	$Panel/rows/chest_row/chest_total.add_color_override("font_color", Color(1,0,0,1))
	$Panel/rows/chest_row/chest_total.text = str(DungeonData.item_totals["chests"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = $timer.time_left
	
	$Panel/rows/fps_row/fps.text = str(Engine.get_frames_per_second())
	
	
	if DungeonData.items_cleared["blood"] < DungeonData.item_totals["blood"]:
		$Panel/rows/blood_row/blood_count.add_color_override("font_color", Color(1,0,0,1))
	else:
		$Panel/rows/blood_row/blood_count.add_color_override("font_color", Color(0,1,0,1))
		$Panel/rows/blood_row/blood_total.add_color_override("font_color", Color(0,1,0,1))
	$Panel/rows/blood_row/blood_count.text = str(DungeonData.items_cleared["blood"])
	
	if DungeonData.items_cleared["bodies"] < DungeonData.item_totals["bodies"]:
		$Panel/rows/body_row/body_count.add_color_override("font_color", Color(1,0,0,1))
	else:
		$Panel/rows/body_row/body_count.add_color_override("font_color", Color(0,1,0,1))
		$Panel/rows/body_row/body_total.add_color_override("font_color", Color(0,1,0,1))
	$Panel/rows/body_row/body_count.text = str(DungeonData.items_cleared["bodies"])
	
	if DungeonData.items_cleared["junk"] < DungeonData.item_totals["junk"]:
		$Panel/rows/junk_row/junk_count.add_color_override("font_color", Color(1,0,0,1))
	else:
		$Panel/rows/junk_row/junk_count.add_color_override("font_color", Color(0,1,0,1))
		$Panel/rows/junk_row/junk_total.add_color_override("font_color", Color(0,1,0,1))
		
	$Panel/rows/junk_row/junk_count.text = str(DungeonData.items_cleared["junk"])
	
	if DungeonData.items_cleared["chests"] < DungeonData.item_totals["chests"]:
		$Panel/rows/chest_row/chest_count.add_color_override("font_color", Color(1,0,0,1))
	else:
		$Panel/rows/chest_row/chest_count.add_color_override("font_color", Color(0,1,0,1))
		$Panel/rows/chest_row/chest_total.add_color_override("font_color", Color(0,1,0,1))
	$Panel/rows/chest_row/chest_count.text = str(DungeonData.items_cleared["chests"])
	
	if time < 20:
		if int(round(time)) % 2 == 0:
			$Panel2/rows/timer/remaining_time.add_color_override("font_color", Color(1,0,0,1))
		else:
			$Panel2/rows/timer/remaining_time.add_color_override("font_color", Color(1,1,1,1))
	
	$Panel2/rows/timer/remaining_time.text = str("%.0f" % time)
	$Panel2/rows/score/score.text = str(DungeonData.score)

func game_over():
	emit_signal("game_over")
	$fail_bkgd/AnimationPlayer.play("fail_anim")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_restart_pressed():
	DungeonData.check_new_high_score()
	DungeonData.new_level()
	get_tree().change_scene("res://Dungeon/Dungeon.tscn")
	

func _on_main_menu_pressed():
	DungeonData.reset_counter()
	DungeonData.check_new_high_score()
	get_tree().change_scene("res://menu/main_menu.tscn")
