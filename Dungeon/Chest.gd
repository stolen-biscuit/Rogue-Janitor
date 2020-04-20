extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_treasure_area_area_entered(area):
	$AnimationPlayer.play("close_lid")
	$AudioStreamPlayer3D.play()
	area.queue_free()
	DungeonData.score += 200
	DungeonData.items_cleared["chests"] += 1
