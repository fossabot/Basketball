extends KinematicBody
var is_dribbling = true
var pos = get_global_transform()
var gravity =90
var jump = 40
var capncrunch = Vector3()
var velocity = Vector3()
var camera
var tppos
var will_ball_score = false
var is_moving = false
var presstime = 0
func start():
	set_global_transform(tppos)
onready var ball = get_node(".")
var anim_player
var character
var robot = true
export var SPEED = 10
const ACCELERATION = 3
const DE_ACCELERATION = 1

signal out
var success = false
var direction = true
var is_timeout = false
var is_ball_moving_forward = false
func _on_timer_timeout():
	success = true
	if is_on_floor():
		capncrunch.y = jump
func _on_Spatial_restart():
	is_timeout = true
var hoop
var distance
func _ready():
	var tppos = get_parent().get_node("Position3D").get_global_transform()
	anim_player = get_node("AnimationPlayer")
	character = get_node(".")
	hoop = get_parent().get_node("hoop")
	
func on_presstime_timeout():
	presstime += 0.1
	$presstime.start()

var shoot_angle

func check_shoot_angle(pos):
	if pos.origin.x < -10:
		return "left"
	else:
		if pos.origin.x < 10:
			return "forward"
		else:
			return "right"

func handle_ball_out():
	emit_signal("out")
	start()
	is_timeout = false

func is_out(pos):
	return (pos.origin.x < -46 or pos.origin.x > 46 or pos.origin.z > 22) and is_on_floor()
	
func are_the_keys_just_pressed():
	return Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("move_fw") or Input.is_action_just_pressed("move_l") or Input.is_action_just_pressed("move_r") or Input.is_action_just_pressed("move_bw")

func is_shoot_pressed():
	return Input.is_action_just_pressed("throw_fw")or Input.is_action_just_pressed("throw_l") or Input.is_action_just_pressed("throw_r")

func set_moving_forward():
	direction = true
	is_moving = true

func set_moving_backward():
	direction = false
	is_moving = true

func move_forward(dir, camera):
	return dir - camera.basis[2]
	
func move_back(dir, camera):
	return dir + camera.basis[2]

func move_left(dir, camera):
	return dir - camera.basis[0]
	
func move_right(dir, camera):
	return dir + camera.basis[0]
	
var currently_pressed_button
var button_pressed_time

func handle_press_timing(button):
	pass
	# if cbutton == urrently pressed:
	# add to presstime
	# else handle presstime and reset it

func _physics_process(delta):
	tppos = get_parent().get_node("Position3D").get_global_transform()
	pos = get_global_transform()
	camera = get_parent().get_node("target").get_global_transform()
	is_moving = false
	var dir = Vector3()
	if is_dribbling:
		if Input.is_action_just_pressed("ui_up"):
			emit_signal("out")
			
		if Input.is_action_pressed("move_fw"):
			dir = move_forward(dir, camera)
			set_moving_forward()
		
		if Input.is_action_pressed("move_bw"):
			dir = move_back(dir, camera)
			set_moving_backward()
		
		if Input.is_action_pressed("move_l"):
			dir = move_forward(dir, camera)
			dir = move_left(dir, camera)
			set_moving_forward()
		
		if Input.is_action_pressed("move_r"):
			dir = move_forward(dir, camera)
			dir = move_right(dir, camera)
			set_moving_forward()
		
		dir.y = 0
		dir = dir.normalized()
		move_and_slide(capncrunch, Vector3.UP)
		if direction and is_moving:
			$AnimationPlayer.play("land")
		if not direction and is_moving:
			$AnimationPlayer.play_backwards("land")
		if is_on_floor():
			capncrunch.y = jump
			#$AnimationPlayer.play("land")
			$audio.play()
			#emit_signal("out")
		if is_out(pos) or is_timeout:
			handle_ball_out()
		if not is_on_floor():
			capncrunch.y -= gravity * delta
			if are_the_keys_just_pressed():
				capncrunch.y = -jump*2
		
		if is_shoot_pressed():
			distance = character.global_transform.origin.distance_to(hoop.global_transform.origin)
			print(distance)
			is_dribbling = false
		
		var hv = velocity
		hv.y = 0
		
		var new_pos = dir * SPEED
		var accel = DE_ACCELERATION
		
		if dir.dot(hv) > 0:
			accel = ACCELERATION
		
		hv = hv.linear_interpolate(new_pos, accel * delta)
		
		velocity.x = hv.x
		velocity.z = hv.z
		
		velocity = move_and_slide(velocity, Vector3(0, 1, 0))	
		
		if is_moving:
			var angle = atan2(hv.x, hv.z)
			var char_rot = character.get_rotation()
			
			char_rot.y = angle
			character.set_rotation(char_rot)
	#if not is_on_floor():
	else:
		move_and_slide(capncrunch, Vector3.UP)
		if Input.is_action_pressed("throw_fw"):
			presstime += delta
		if Input.is_action_just_released("throw_fw"):
			is_moving = true
			shoot_angle = check_shoot_angle(pos)
			if shoot_angle == "forward":
				will_ball_score = true
			else:
				will_ball_score = false
			print(will_ball_score)
		if Input.is_action_pressed("throw_l"):
			presstime += delta
		if Input.is_action_just_released("throw_l"):
			is_moving = true
			shoot_angle = check_shoot_angle(pos)
			if shoot_angle == "left":
				will_ball_score = true
			else:
				will_ball_score = false
			print(will_ball_score)
		if Input.is_action_pressed("throw_r"):
			presstime += delta
		if Input.is_action_just_released("throw_r"):
			is_moving = true
			shoot_angle = check_shoot_angle(pos)
			if shoot_angle == "right":
				will_ball_score = true
			else:
				will_ball_score = false
			print(will_ball_score)
		if not will_ball_score:
			if shoot_angle == "forward":
				SPEED = 50
				if not pos.origin.z < 22:
					if pos.origin.y < 10:
						capncrunch.y = jump
					dir -= camera.basis[2]
					if not is_on_floor():
						capncrunch.y -= gravity * delta
					yield(get_tree(), "idle_frame")
		dir.y = 0
		dir = dir.normalized()
		var hv = velocity
		hv.y = 0
		
		var new_pos = dir * SPEED
		var accel = DE_ACCELERATION
		
		if dir.dot(hv) > 0:
			accel = ACCELERATION
		
		hv = hv.linear_interpolate(new_pos, accel * delta)
		
		velocity.x = hv.x
		velocity.z = hv.z
		
		velocity = move_and_slide(velocity, Vector3(0, 1, 0))	
		if is_moving:
			var angle = atan2(hv.x, hv.z)
			var char_rot = character.get_rotation()
			
			char_rot.y = angle
			character.set_rotation(char_rot)
