extends Node2D

#need to implement length. 
var LimitedLazer = 100 
#Lazer is offset from raycast I think due to this onready, needs to be restructured
@onready var line = $RayCast2D/Line2D

func _process(_delta):

	global_rotation = 0.0
	look_at(get_global_mouse_position())
	line.points[1] = get_global_mouse_position() - line.global_position
	
