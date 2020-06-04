extends KinematicBody

var posPlayer = get_global_transform()

var gravity =15
var jump = 12
var capncrunch = Vector3()
var velocity = Vector3()
onready var camera
var anim_player
var character
var robot = true
export var SPEED = 10
const ACCELERATION =3
const DE_ACCELERATION = 5

var success = false

func track_time_button():
	var button_time = 2
	if Input.is_action_just_pressed("jump"):
		$HoldTime.start(button_time)
	if button_time > 2:
		$HoldTime.stop()
		if success:
			$AnimationPlayer.play("Robot_Death")
			robot = false
			success = false


func _on_timer_timeout():
	success = true
	if is_on_floor():
		capncrunch.y = jump
		$AnimationPlayer.play("Robot_Jump")

func _ready():
	anim_player = get_node("AnimationPlayer")
	character = get_node(".")
	
func _physics_process(delta):
	if robot == true:
		camera = get_node("../Camera").get_global_transform()
		var is_moving = false
		var dir = Vector3()
		if Input.is_action_pressed("move_fw"):
			dir += -camera.basis[2]
			is_moving = true
			$AnimationPlayer.play("Robot_Running")
		if Input.is_action_pressed("move_l"):
			$AnimationPlayer.play("Robot_Walking")
			dir += -camera.basis[2]
			dir += -camera.basis[0]
			is_moving = true
		if Input.is_action_pressed("move_r"):
			$AnimationPlayer.play("Robot_Walking")
			dir += -camera.basis[2]
			dir += camera.basis[0]
			is_moving = true
		if is_moving == false:
			$AnimationPlayer.play("Robot_Idle")
		
		dir.y = 0
		dir = dir.normalized()
		move_and_slide(capncrunch, Vector3.UP)
		if not is_on_floor():
			capncrunch.y -= gravity * delta
			$AnimationPlayer.play("Robot_Jump")
		if Input.is_action_pressed("jump"):
			$AnimationPlayer.play_backwards("Robot_Jump")
			track_time_button()
		if Input.is_action_just_released("jump") and is_on_floor():
			capncrunch.y = jump
			$AnimationPlayer.play("Robot_Jump")
		if not Input.is_action_just_pressed("jump") and not is_on_floor():
			$AnimationPlayer.play("Robot_Jump")
			
		#if Input.is_action_just_pressed("jump") and is_on_floor():
			#capncrunch.y = jump
	
		
		
		
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
