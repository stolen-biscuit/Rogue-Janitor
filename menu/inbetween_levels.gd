extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	DungeonData.check_new_high_score()
	$score.text = str(DungeonData.score)
	$hi_score.text =str(DungeonData.high_score)
	$level.text = str(DungeonData.level)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_continue_pressed():
	DungeonData.check_new_high_score()
	DungeonData.new_level()
	DungeonData.level += 1
	get_tree().change_scene_to(load("res://Dungeon/Dungeon.tscn"))


func _on_main_menu_pressed():
	DungeonData.check_new_high_score()
	DungeonData.reset_counter()
	DungeonData.reset_level_counter()
	get_tree().change_scene("res://menu/main_menu.tscn")
