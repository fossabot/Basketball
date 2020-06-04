extends KinematicBody

var gravity =15
var jump = 12
var capncrunch = Vector3()
var velocity = Vector3()
var camera
var anim_player
var character
var robot = true
var SPEED = 10
const ACCELERATION =3
const DE_ACCELERATION = 5

var success = false


func _ready():
	camera = get_node("Camera").get_global_transform()
func _physics_process(delta):
	if robot == true:
		SPEED = 10
		var is_moving = false
		var dir = Vector3()
		if Input.is_action_pressed("move_fw"):
			dir += -camera.basis[2]
			is_moving = true
			SPEED = 10
		if Input.is_action_pressed("move_l"):
			dir += -camera.basis[2]
			is_moving = true
			SPEED = SPEED*0.714
		if Input.is_action_pressed("move_r"):
			dir += -camera.basis[2]
			is_moving = true
			SPEED = SPEED*0.714
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
	#if not is_on_floor():
		#$AnimationPlayer.play("Robot_Jump")

	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):gle
#	pass
