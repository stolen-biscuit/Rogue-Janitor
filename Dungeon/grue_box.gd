extends "res://Dungeon/dungeon_item.gd"

var base_rotation = Vector3(0,0,0)
signal drop_item

func _ready():
	base_rotation = get_rotation().z

func move_item(new_pos, part):
	#part.global_transform.origin = new_pos
	for node in get_children():
		if node is RigidBody:
			new_pos.y = 0.5
			node.global_transform.origin = new_pos

func fix_rotation():
	print(transform.origin)
	rotate_z(120)
	print(transform.origin)
	transform.origin.y = 0.5
	

func is_pickable(body):
	return true

func eat(body_part):
	body_part.get_parent().eat_part(body_part)

func _on_eating_area_area_entered(area):
	var body = area.get_parent()
	print(area.name)
	$AnimationPlayer.play("eating")
	$box/AudioStreamPlayer3D.play()
	emit_signal("drop_item")
	eat(body)
	$box/AudioStreamPlayer3D.stop()
	$AnimationPlayer.play("Finished Eating")
	yield($AnimationPlayer, "animation_finished")


func _on_eating_area_area_exited(area):
	get_tree().create_timer(1.0)
	$box/AudioStreamPlayer3D.stop()
	$AnimationPlayer.play("Finished Eating")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("Shifty Eyes")


func _on_detection_area_area_entered(area):
	$AnimationPlayer.play("eating")
	$box/AudioStreamPlayer3D.play()


func _on_detection_area_area_exited(area):
	$AnimationPlayer.play("Shifty Eyes")
	$box/AudioStreamPlayer3D.stop()
