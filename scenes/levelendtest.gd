#TODO add class
extends Area2D


func _on_body_entered(body):
	if body is Boulder:
		get_tree().change_scene_to_file("res://scenes/cutscene_test.tscn") #TODO rework into game state
