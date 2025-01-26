class_name Scoreboard
extends Control

@onready var score_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/ScoreLabel
@onready var timer_label: Label = $MarginContainer/VBoxContainer/TimerLabel

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


func update_timer_label(seconds: float):
	var minutes = int(seconds) / 60
	var rem_seconds = int(seconds) % 60
	var milliseconds = int((seconds - int(seconds)) * 100)
	var timestamp = "%02d:%02d.%02d" % [minutes, rem_seconds, milliseconds]
	
	timer_label.text = timestamp
	if seconds <= 5:
		timer_label.add_theme_color_override('font_color', Color.RED)
	else:
		timer_label.add_theme_color_override('font_color', Color.WHITE)
