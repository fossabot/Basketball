extends KinematicBody

var gravity =90
var jump = 40
var capncrunch = Vector3()
var velocity = Vector3()
var camera
var anim_player
var character
var robot = true
export var SPEED = 10
const ACCELERATION =3
const DE_ACCELERATION = 1

var success = false

func _on_timer_timeout():
	success = true
	if is_on_floor():
		capncrunch.y = jump

func _ready():
	anim_player = get_node("AnimationPlayer")
	character = get_node(".")
	
func _physics_process(delta):
	if robot == true:
		camera = get_parent().get_node("target").get_global_transform()
		var is_moving = false
		var dir = Vector3()
		if Input.is_action_pressed("move_fw"):
			dir += -camera.basis[2]
			is_moving = true
		if Input.is_action_pressed("move_l"):
			dir += -camera.basis[2]
			dir += -camera.basis[0]
			is_moving = true
		if Input.is_action_pressed("move_r"):
			dir += -camera.basis[2]
			dir += camera.basis[0]
			is_moving = true
		dir.y = 0
		dir = dir.normalized()
		move_and_slide(capncrunch, Vector3.UP)
		if is_on_floor():
			capncrunch.y = jump
			$AnimationPlayer.play("land")
			$audio.play()
		if not is_on_floor():
			capncrunch.y -= gravity * delta
			$ball.scale.y = 4
		if not is_on_floor() and Input.is_action_just_pressed("jump"):
			capncrunch.y = -jump*2
		if not is_on_floor() and Input.is_action_just_pressed("move_fw"):
			capncrunch.y = -jump*2
		if not is_on_floor() and Input.is_action_just_pressed("move_l"):
			capncrunch.y = -jump*2
		if not is_on_floor() and Input.is_action_just_pressed("move_r"):
			capncrunch.y = -jump*2
		
		
		
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
		#$AnimationPlayer.play("Robot_Jump")

	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):gle
#	pass
