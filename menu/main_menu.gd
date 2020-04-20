extends Control

func _ready():
	DungeonData.score = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_normal_pressed():
	DungeonData.time_limit = 120
	DungeonData.reset_level_counter()
	DungeonData.new_level()
	get_tree().change_scene("res://Dungeon/Dungeon.tscn")


func _on_tutorial_pressed():
	$TextureRect.show()
	$normal.hide()
	$hard.hide()
	$challenge.hide()


func _on_hard_pressed():
	DungeonData.time_limit = 90
	DungeonData.reset_level_counter()
	DungeonData.new_level()
	get_tree().change_scene("res://Dungeon/Dungeon.tscn")


func _on_challenge_pressed():
	DungeonData.time_limit = 60
	DungeonData.reset_level_counter()
	DungeonData.new_level()
	get_tree().change_scene("res://Dungeon/Dungeon.tscn")


func _on_close_help_pressed():
	$TextureRect.hide()
	$normal.show()
	$hard.show()
	$challenge.show()
