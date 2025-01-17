class_name DeathZone
extends Area2D


func _on_body_entered(body):
	if body is Boulder:
		# TODO: Kill boulder, disable inputs
		# TODO: Show death screen via UILayer
		GameState.freeze_camera()
