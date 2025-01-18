extends StaticBody2D


func _on_shootable_was_hit():
	show()
	collision_layer = 2
