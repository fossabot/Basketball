extends KinematicBody
var state = true
var pos = get_global_transform()
var gravity =90
var jump = 40
var capncrunch = Vector3()
var velocity = Vector3()
var camera
var tppos
var presstime = 0
func start():
	set_global_transform(tppos)
onready var ball = get_node(".")
var anim_player
var character
var robot = true
export var SPEED = 10
const ACCELERATION =3
const DE_ACCELERATION = 1
signal out
var success = false
var direction = true
var ballout
var ball_direction = false
func _on_timer_timeout():
	success = true
	if is_on_floor():
		capncrunch.y = jump
func _on_Spatial_restart():
	ballout = true
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
	if pos.origin.x < 10 and pos.origin.x > -10:
		shoot_angle = "forward"
	if pos.origin.x < -10:
		shoot_angle = "left"
	if pos.origin.x > 10:
		shoot_angle = "right"
func _physics_process(delta):
	if state:
		tppos = get_parent().get_node("Position3D").get_global_transform()
		pos = get_global_transform()
		camera = get_parent().get_node("target").get_global_transform()
		var is_moving = false
		var dir = Vector3()
		if Input.is_action_just_pressed("ui_up"):
			emit_signal("out")
		if Input.is_action_pressed("move_fw"):
			dir += -camera.basis[2]
			direction = true
			is_moving = true
		if Input.is_action_pressed("move_bw"):
			dir += camera.basis[2]
			is_moving = true
			direction = false
		if Input.is_action_pressed("move_l"):
			dir += -camera.basis[2]
			dir += -camera.basis[0]
			direction = true
			is_moving = true
		if Input.is_action_pressed("move_r"):
			dir += -camera.basis[2]
			dir += camera.basis[0]
			direction = true
			is_moving = true
		dir.y = 0
		dir = dir.normalized()
		move_and_slide(capncrunch, Vector3.UP)
		if direction == true and is_moving == true:
			$AnimationPlayer.play("land")
		if direction == false and is_moving == true:
			$AnimationPlayer.play_backwards("land")
		if is_on_floor():
			capncrunch.y = jump
			#$AnimationPlayer.play("land")
			$audio.play()
			#emit_signal("out")
		if (is_on_floor() and pos.origin.z > 22) or ballout == true:
			emit_signal("out")
			start()
			ballout = false
			
		if (is_on_floor() and pos.origin.x > 46) or ballout == true:
			emit_signal("out")
			start()
			ballout = false
			
		if (is_on_floor() and pos.origin.x < -46) or ballout == true:
			emit_signal("out")
			start()
			ballout = false
			
		if not is_on_floor():
			capncrunch.y -= gravity * delta
			#$ball.scale.y = 2
		if not is_on_floor() and Input.is_action_just_pressed("jump"):
			capncrunch.y = -jump*2
		
		if not is_on_floor() and Input.is_action_just_pressed("move_fw"):
			capncrunch.y = -jump*2
		
		if not is_on_floor() and Input.is_action_just_pressed("move_l"):
			capncrunch.y = -jump*2
		
		if not is_on_floor() and Input.is_action_just_pressed("move_r"):
			capncrunch.y = -jump*2
		
		if not is_on_floor() and Input.is_action_just_pressed("move_bw"):
			capncrunch.y = -jump*2
		
		
		#if Input.is_action_pressed("throw_fw"):
			#dir += -camera.basis[2]
		#if Input.is_action_just_pressed("throw_fw"):
			#capncrunch.y = jump *1.5
		if Input.is_action_just_pressed("throw_fw"):
			distance = character.global_transform.origin.distance_to(hoop.global_transform.origin)
			print(distance)
			state = false
		
		#if Input.is_action_pressed("throw_l"):
			#dir += -camera.basis[2]
			#dir += -camera.basis[0]
		#if Input.is_action_just_pressed("throw_l"):
			#capncrunch.y = jump *1.5
		if Input.is_action_just_pressed("throw_l"):
			distance = character.global_transform.origin.distance_to(hoop.global_transform.origin)
			print(distance)
			state = false
		
		#if Input.is_action_pressed("throw_r"):
			#dir += -camera.basis[2]
			#dir += camera.basis[0]
		#if Input.is_action_just_pressed("throw_r"):
			#capncrunch.y = jump *1.5
		if Input.is_action_just_pressed("throw_r"):
			distance = character.global_transform.origin.distance_to(hoop.global_transform.origin)
			print(distance)
			state = false
		
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
		if Input.is_action_pressed("throw_fw"):
			presstime += delta
		if Input.is_action_just_released("throw_fw"):
			presstime = presstime
			check_shoot_angle(pos)
			if shoot_angle == "forward":
				ball_direction = true
			print(ball_direction)
		if Input.is_action_pressed("throw_l"):
			presstime += delta
		if Input.is_action_just_released("throw_l"):
			presstime = presstime
			check_shoot_angle(pos)
			if shoot_angle == "left":
				ball_direction = true
			print(ball_direction)
		if Input.is_action_pressed("throw_r"):
			presstime += delta
		if Input.is_action_just_released("throw_r"):
			presstime = presstime
			check_shoot_angle(pos)
			if shoot_angle == "right":
				ball_direction = true
			print(ball_direction)
			
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):gle
#	pass



