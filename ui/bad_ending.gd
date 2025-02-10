class_name BadEnding
extends Control

@onready var label = $MarginContainer/VBoxContainer/EnemyLabel


func _on_visibility_changed():
	if !visible: return
	
	var escaped: int = GameState.max_kill_count - GameState.total_kill_count
	if escaped == 1:
		label.text = '( ' + str(escaped) + ' enemy lived to tell the tale... )'
	else:
		label.text = '( ' + str(escaped) + ' enemies lived to tell the tale... )'


func _on_retry_pressed():
	hide()
	UILayer.show_main_menu()


func _on_credits_pressed():
	hide()
	UILayer.show_credits()
