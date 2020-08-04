extends Spatial
var time = 30
#onready var ScoreTimer = get_node("ScoreTimer")
signal restart
func _process(delta):
	if time == 0:
		emit_signal("restart")
		time = 30
		$HUD.show_timeout()
func _on_ball_out():
	pass
	#get_tree().reload_current_scene()
func _on_ScoreTimer_timeout():
	time -= 1
	$HUD.update_score(time)
func _on_target_pepe():
	$Camera.current = true # Replace with function body.
