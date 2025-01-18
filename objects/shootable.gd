class_name Shootable
extends Area2D

signal was_hit


func reset():
	process_mode = PROCESS_MODE_INHERIT
	show()


func hit():
	hide()
	process_mode = PROCESS_MODE_DISABLED
	was_hit.emit()
