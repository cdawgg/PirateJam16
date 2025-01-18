class_name MainMenu
extends Control


func _on_play_pressed():
	hide()
	GameState.load_level(load("res://scenes/test_level.tscn"))
	UILayer.show_scoreboard()
