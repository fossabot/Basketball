extends Spatial
var time = 0
#onready var ScoreTimer = get_node("ScoreTimer")

func _process(delta):
	if time > 29:
		pass#get_tree().reload_current_scene()
func _on_ball_out():
	pass
	#get_tree().reload_current_scene()
func _on_ScoreTimer_timeout():
	time += 1
	$HUD.update_score(time)
func _on_target_pepe():
	$Camera.current = true # Replace with function body.
