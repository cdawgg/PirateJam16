class_name DeathZone
extends Area2D


func _on_body_entered(body):
	if body is Boulder:
		body.die()
