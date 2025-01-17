class_name Enemy
extends Area2D

var dead: bool = false


func die():
	hide()
	dead = true


func respawn():
	show()
	dead = false


func _on_body_entered(body):
	if body is Boulder:
		die()
