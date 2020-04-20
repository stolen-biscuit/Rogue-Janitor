extends Spatial
var is_grabbing = false
const base_position = Vector3(-0.53, -.41, 0.8)

signal can_grab(body)

func reset_hand():
	translation = base_position

func open_hand():
	is_grabbing = false
	$AnimationPlayer.play("Open Hand")

func grab():
	is_grabbing = true
	$AnimationPlayer.play("Close Hand")

func _on_grab_area_body_entered(body):
	if body is StaticBody:
		if !body.is_in_group("pickable"):
			return
	if body.get_parent().is_pickable(body):
		emit_signal("can_grab", body)
