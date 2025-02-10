class_name LevelEndScreen
extends Control

@onready var score_label: RichTextLabel = $MarginContainer/VBoxContainer/GridContainer/EnemyScoreLabel
@onready var kill_label: RichTextLabel = $MarginContainer/VBoxContainer/GridContainer/KillCountLabel
@onready var time_label: RichTextLabel = $MarginContainer/VBoxContainer/GridContainer/TimeAmountLabel


func _ready():
	hide()


func _on_visibility_changed():
	if !visible: return
	
	score_label.text = '[right]' + str(GameState.level_kill_count) + ' / ' + str(GameState.level.enemies.size())
	kill_label.text = '[right]' + str(GameState.total_kill_count + GameState.level_kill_count) + ' / ' + str(GameState.max_kill_count + GameState.level.enemies.size())
	time_label.text = '[right]' + UILayer.scoreboard.timer_label.text


func _on_retry_button_pressed():
	await UILayer.fade_screen(0.2)
	GameState.restart_level()
	hide()
	UILayer.fade_screen(0.2, true)


func _on_next_button_pressed():
	await UILayer.fade_screen(0.2)
	GameState.load_next_level()
	hide()
	UILayer.fade_screen(0.2, true)
