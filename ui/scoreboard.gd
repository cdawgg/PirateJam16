class_name Scoreboard
extends VBoxContainer

@onready var enemy_count: Label = $MarginContainer/VBoxContainer/EnemyCount
@onready var score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel


func set_enemy_count(count: int):
	enemy_count.text = "Enemies on Level: " + str(count)


func set_score(score: int):
	score_label.text = "Total body count: " + str(score)
