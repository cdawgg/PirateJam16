class_name MainMenu
extends Control


func _on_play_pressed():
	hide()
	GameState.load_level(0)
	UILayer.show_scoreboard()
