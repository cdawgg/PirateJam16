extends Area2D

@export var lines: Array[String] 

#unused
#const lines: Array[String] = [
#	"This is a sign",
#	"This is a second line",
#]


func _on_body_entered(body):
	if body is Boulder:
		DialogManager.start_dialog(global_position, lines)


func _on_body_exited(body):
	#if body is Boulder:
	#	DialogManager._on_text_box_finished_displaying()
	return
