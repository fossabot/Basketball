extends CanvasLayer

func update_score(time):
	$TimeLabel.text = str(time)
func show_timeout():
	$TimeoutLabel.visible = true
	yield(get_tree().create_timer(0.3), "timeout")
	$TimeoutLabel.visible = false
	yield(get_tree().create_timer(0.3), "timeout")
	$TimeoutLabel.visible = true
	yield(get_tree().create_timer(0.3), "timeout")
	$TimeoutLabel.visible = false
	yield(get_tree().create_timer(0.3), "timeout")
	$TimeoutLabel.visible = true
	yield(get_tree().create_timer(0.3), "timeout")
	$TimeoutLabel.visible = false
	
