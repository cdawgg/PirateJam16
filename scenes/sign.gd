extends Area2D


const lines: Array[String] = [
	"This is a sign.",
	"This is the second line.",
]


func _on_body_entered(body):
	if body is Boulder:
		DialogManager.start_dialog(global_position, lines)


func _on_body_exited(body):
	#TODO close dialog box on exit. Above statement doesn't do this.
	return
