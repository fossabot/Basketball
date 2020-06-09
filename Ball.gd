extends RigidBody
var down = Vector3.DOWN
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func integrateforces(state):
	var forcex = Vector3.DOWN
	state.add_force(forcex, Vector3(0,0,0))
func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		add_force(down, Vector3(0,0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
