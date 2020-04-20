extends Node




var song: AudioStreamPlayer
var items_cleared = {
	chests = 0,
	blood = 0,
	bodies = 0,
	junk = 0
}
var item_totals = {
	chests = 0,
	blood = 0,
	bodies = 0,
	junk = 0
}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func reset_counter():
	items_cleared.clear()
	items_cleared = {
		chests = 0,
		blood = 0,
		bodies = 0,
		junk = 0
	}

func new_level():
	reset_counter()
	item_totals.clear()
	item_totals = {
		chests = 0,
		blood = 0,
		bodies = 0,
		junk = 0
	}

func reset_level_counter():
	level = 1

func check_new_high_score():
	if score > high_score:
		high_score = score
		save_high_score()

func save_high_score():
	var file = File.new()
	file.open("user://high_score.txt", File.WRITE)
	file.store_string(str(high_score))
	file.close()

func load_high_score():
	var file = File.new()
	if file.open("user://high_score.txt", File.READ) == OK:
		high_score = int(file.get_as_text())
	file.close()
		

var high_score = 0
var score = 0
var time_limit = 90
var level = 1
var game_active = true
# Called when the node enters the scene tree for the first time.
func _ready():
	load_high_score()
	song = AudioStreamPlayer.new()
	song.set_stream(load("res://assets/audio/rogue_janitor.ogg"))
	add_child(song)
	song.play()
	song.volume_db = -10


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
