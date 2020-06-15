extends KinematicBody
var pos = get_global_transform()
var gravity =90
var jump = 40
var capncrunch = Vector3()
var velocity = Vector3()
var camera
var tppos
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

func _on_timer_timeout():
	success = true
	if is_on_floor():
		capncrunch.y = jump

func _ready():
	#var tppos = get_parent().get_node("Position3D").get_global_transform()
	anim_player = get_node("AnimationPlayer")
	character = get_node(".")
	
func _physics_process(delta):
	if robot == true:
		tppos = get_parent().get_node("Position3D").get_global_transform()
		var pos = get_global_transform()
		camera = get_parent().get_node("target").get_global_transform()
		var is_moving = false
		var dir = Vector3()
		if Input.is_action_just_pressed("ui_up"):
			emit_signal("out")
		if Input.is_action_pressed("move_fw"):
			dir += -camera.basis[2]
			is_moving = true
		if Input.is_action_pressed("move_bw"):
			dir += camera.basis[2]
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
			#$AnimationPlayer.play("land")
			$audio.play()
			#emit_signal("out")
		if is_on_floor() and pos.origin.z > 22:
			emit_signal("out")
			start()
		if is_on_floor() and pos.origin.x > 46:
			emit_signal("out")
			start()
		if is_on_floor() and pos.origin.x < -46:
			emit_signal("out")
			start()
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
		if Input.is_action_pressed("throw_fw"):
			dir += -camera.basis[2]
		if Input.is_action_just_pressed("throw_fw"):
			capncrunch.y = jump *1.5
		if Input.is_action_pressed("throw_l"):
			dir += -camera.basis[2]
			dir += -camera.basis[0]
		if Input.is_action_just_pressed("throw_l"):
			capncrunch.y = jump *1.5
		if Input.is_action_pressed("throw_r"):
			dir += -camera.basis[2]
			dir += camera.basis[0]
		if Input.is_action_just_pressed("throw_r"):
			capncrunch.y = jump *1.5
		
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
