class_name Enemy
extends Area2D

var dead: bool = false


func die():
	hide()
	dead = true
	set_deferred("process_mode", PROCESS_MODE_DISABLED)
	
	GameState.level_kill_count += 1
	GameState.shake_camera(0.5)


func respawn():
	show()
	dead = false
	process_mode = PROCESS_MODE_INHERIT


func _on_body_entered(body):
	if body is Boulder:
		die()
