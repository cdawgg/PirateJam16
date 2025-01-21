class_name Scoreboard
extends Control

@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel

var enemy_count: int = 0:
	set(val):
		enemy_count = val
		update_score_label()
var kill_count: int = 0:
	set(val):
		kill_count = val
		update_score_label()


func update_score_label():
	score_label.text = str(kill_count) + ' / ' + str(enemy_count)
