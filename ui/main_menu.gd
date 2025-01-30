class_name MainMenu
extends Control

@onready var menu_music: AudioStream = preload("res://assets/music/uh.ogg")

@onready var intro_video: VideoStream = preload("res://assets/Intro.ogv")
@onready var intro_music: AudioStream = preload("res://assets/music/cave.ogg")


func _ready():
	SoundPlayer.play_music(menu_music)


func _on_play_pressed():
	UILayer.fade_screen(3)
	await SoundPlayer.fade_music(0, 4)
	hide()
	
	SoundPlayer.play_music(intro_music)
	SoundPlayer.fade_music(1, 3, true)
	UILayer.fade_screen(1.5, true)
	await UILayer.play_video(intro_video)
	
	GameState.load_level(0)
	UILayer.show_scoreboard()
