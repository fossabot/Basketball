extends KinematicBody
signal out
var gravity =15
var jump = 16
var capncrunch = Vector3()
var velocity = Vector3()
var camera
var tppos 
var anim_player
var character
var robot = true
var SPEED = 10
const ACCELERATION =3
const DE_ACCELERATION = 1
signal pepe
var success = false
var ballout = false
var startpos
var startz
var counter
func _on_ball_out():
	ballout = true
func _on_Spatial_restart():
	ballout = true # Replace with function body.
var pos
func _ready():
	camera = get_node("lol").get_global_transform()
	var character = get_node(".")
	startpos = get_global_transform()
func _process(delta):
	pass
func _physics_process(delta):
	if robot == true:
		SPEED = 10
		pos = get_global_transform()
		tppos = get_parent().get_node("Position3D2").get_global_transform()
		var is_moving = false
		var dir = Vector3()
		if Input.is_action_pressed("move_fw") or Input.is_action_pressed("throw_fw"):
			dir += -camera.basis[2]
			is_moving = true
			SPEED = 10
		if Input.is_action_pressed("move_bw"):
			dir += camera.basis[2]
			is_moving = true
			SPEED =10
		if Input.is_action_pressed("move_l"):
			dir += -camera.basis[2]
			is_moving = true
			SPEED = SPEED*0.714
		if Input.is_action_pressed("move_r"):
			dir += -camera.basis[2]
			is_moving = true
			SPEED = SPEED*0.714
		if ballout == true:
			if pos.origin.z > tppos.origin.z:
				dir += camera.basis[2]
				is_moving = true
				SPEED =30
			else:
				ballout = false
				SPEED = 0
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




