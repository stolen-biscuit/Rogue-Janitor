extends KinematicBody

export var gravity = -30
var velocity = Vector3()
export var speed = 11
export var accel = 4.5
export var deacceleration = 16

var dir = Vector3()
var camera
var rotator
var can_grab = false
var held_item
var holdable_item
var force: Vector3
var mouse_pos: Vector3
export var mouse_sensitivity = 0.7

var gem_scene = preload("res://Janitor/gem.tscn")
var gem_count = 0

func _ready():
	camera = $Rotator/Camera
	rotator = $Rotator
	$hand.connect("can_grab", self, "grab_object")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for grue_box in get_tree().get_nodes_in_group("grue_box"):
		grue_box.connect("drop_item", self, "drop_item")
	#Input.set_custom_mouse_cursor(load("res://assets/cursor.png"))

func grab_object(object):
	can_grab = true

func _physics_process(delta):
	var camera_transform = camera.get_global_transform()
	var hvelocity
	var target
	var acceleration
	var input_movement_vector = Vector2()
	
	var ray_origin
	var ray_direction
	var from
	var to
	var space_state
	var hit
	var mouse_pos
	if DungeonData.game_active:
		dir = Vector3()
		holdable_item = null
		if Input.is_action_pressed("move_fw"):
			input_movement_vector.y += 1
		if Input.is_action_pressed("move_bw"):
			input_movement_vector.y -= 1
		if Input.is_action_pressed("move_left"):
			input_movement_vector.x -= 1
		if Input.is_action_pressed("move_right"):
			input_movement_vector.x += 1
	
		input_movement_vector = input_movement_vector.normalized()
	
		dir += -camera_transform.basis.z * input_movement_vector.y
		dir += camera_transform.basis.x * input_movement_vector.x
	
		dir.y = 0
		dir = dir.normalized()
	
		velocity.y += delta * gravity
	
		hvelocity = velocity
		hvelocity.y = 0
		target = dir
		target *= speed
	
		if dir.dot(hvelocity) > 0:
			acceleration = accel
		else:
			acceleration = deacceleration
	
		hvelocity = hvelocity.linear_interpolate(target, acceleration * delta)
		velocity.x = hvelocity.x
		velocity.z = hvelocity.z
		velocity = move_and_slide(velocity, Vector3(0, 1, 0), 0.05, 4)
		
		mouse_pos = get_viewport().get_mouse_position()
		ray_origin = $Rotator/Camera.project_ray_origin(mouse_pos)
		ray_direction = $Rotator/Camera.project_ray_normal(mouse_pos)
		
		from = ray_origin
		to = ray_origin + ray_direction * 2
		space_state = get_world().get_direct_space_state()
		hit = space_state.intersect_ray(from, to)
		$reticule.global_transform.origin = ray_origin +ray_direction
		if hit.size() != 0:
			if hit.collider is StaticBody:
				if !hit.collider.is_in_group("pickable"):
					return
			if hit.collider is MeshInstance:
				return
			#print(hit.collider.get_parent().name)
			if hit.collider.get_parent().is_pickable(hit.collider):
				can_grab = true
				$hand.translation = Vector3(0,0,0)
				$hand.global_transform.origin = hit.position
				$reticule.global_transform.origin = hit.position
				if held_item == null:
					if hit.collider.name == "gem_spawner":
						if gem_count < 7:
							var gem = gem_scene.instance()
							get_parent().add_child(gem)
							gem.global_transform.origin = hit.position
							holdable_item = gem.get_node("RigidBody")
							gem_count += 1
					else:
						holdable_item = hit.collider
				else:
					holdable_item = null
		else:
			#var fixed_pos = ray_origin +ray_direction
			#fixed_pos.y -= 0.5
			#$hand.global_transform.origin = fixed_pos
			$hand.reset_hand()
			#print(fixed_pos)
			can_grab = false
			#$hand.reset_hand()
		if held_item != null:
			if held_item is StaticBody:
				if !held_item.is_in_group("pickable"):
					return
			held_item.get_parent().move_item(ray_origin+ray_direction, held_item)
			#held_item.global_transform.origin = ray_origin + ray_direction

func _input(event):
	if DungeonData.game_active:
		if Input.is_action_just_pressed("ui_cancel"):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#if Input.is_action_pressed("ui_select"):
		#	if held_item != null:
		##		if held_item.name == "box":
		#			held_item.get_parent().fix_rotation()
		if event is InputEventMouseButton:
			if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
				if event.button_index == BUTTON_LEFT and event.pressed:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				if Input.is_action_pressed("grab"):
					$hand.grab()
					if holdable_item != null:
						held_item = holdable_item
						held_item.get_parent().grab()
						holdable_item = null
				if Input.is_action_just_released("grab"):
					$hand.open_hand()
					if held_item != null:
						held_item.get_parent().drop(Vector3(0,0,0))
						held_item = null
						holdable_item = null
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotator.rotate_x(deg2rad(event.relative.y * mouse_sensitivity))
			self.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))
	
			var camera_rot = rotator.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -70, 70)
			rotator.rotation_degrees = camera_rot

func drop_item():
	holdable_item = null
	held_item = null
