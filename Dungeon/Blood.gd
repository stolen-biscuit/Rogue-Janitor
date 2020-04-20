extends "res://Dungeon/dungeon_item.gd"

var reduce_x_size
var reduce_z_size

var cool_down_timer: Timer
var can_clean = true

func _timer_done():
	can_clean = true

var blood_spots = {
	spot1 = false,
	spot2 = false,
	spot3 = false,
	spot4 = false,
	spot5 = false,
	spot6 = false,
	spot7 = false,
	spot8 = false,
	spot9 = false
}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	# We do this when cleaning blood spots to have a linear
	# Reduction of size
	reduce_x_size = scale.x/9
	reduce_z_size = scale.z/9
	cool_down_timer = Timer.new()
	cool_down_timer.set_one_shot(true)
	cool_down_timer.connect("timeout", self, "_timer_done")
	add_child(cool_down_timer)
	#print(cool_down_timer.get_signal_connection_list("timeout"))
	
func check_if_cleaned():
	var cleaned = true
	for spot in blood_spots.keys():
		if !blood_spots[spot]:
			cleaned = false
			break
	if cleaned:
		DungeonData.items_cleared["blood"] += 1
		DungeonData.score += 50
		$cleaned.play()
		$Cylinder.hide()
		yield($cleaned, "finished")
		queue_free()

func clean_spot(spot):
	var scale_tween = Tween.new()
	if !blood_spots[spot]:
		if can_clean:
			$cleaning.play()
			can_clean = false
			var intended_scale = scale
			intended_scale.x -= reduce_x_size
			intended_scale.z -= reduce_z_size
			scale_tween.interpolate_property(self, "scale", scale, intended_scale, 0.1)
			#z_tween.interpolate_property(self, "scale.z", scale.z, scale.z-reduce_z_size, 0.1)
			add_child(scale_tween)
			#add_child(z_tween)
			#x_tween.start()
			scale_tween.start()
			#scale.x -= reduce_x_size
			#scale.z -= reduce_z_size
			blood_spots[spot] = true
			cool_down_timer.start(0.05)
			check_if_cleaned()


func _on_spot1_area_entered(area):
	clean_spot("spot1")


func _on_spot2_area_entered(area):
	clean_spot("spot2")


func _on_spot3_area_entered(area):
	clean_spot("spot3")


func _on_spot4_area_entered(area):
	clean_spot("spot4")


func _on_spot5_area_entered(area):
	clean_spot("spot5")


func _on_spot6_area_entered(area):
	clean_spot("spot6")


func _on_spot7_area_entered(area):
	clean_spot("spot7")


func _on_spot8_area_entered(area):
	clean_spot("spot8")


func _on_spot9_area_entered(area):
	clean_spot("spot9")
