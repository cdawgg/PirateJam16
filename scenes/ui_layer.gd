extends CanvasLayer

@onready var main_menu: MainMenu = $MainMenu
@onready var scoreboard: Scoreboard = $Scoreboard
@onready var death_screen: Control = $DeathScreen
@onready var level_end_screen: LevelEndScreen = $LevelEndScreen
@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var screen_cover: ColorRect = $ScreenCover
@onready var credits: Credits = $Credits
@onready var settings: Settings = $Settings


func _ready():
	scoreboard.hide()
	death_screen.hide()
	level_end_screen.hide()
	video_player.hide()
	screen_cover.hide()
	credits.hide()
	settings.hide()
	
	main_menu.show()

func show_main_menu(show: bool = true):
	main_menu.visible = show


func show_scoreboard(show: bool = true):
	scoreboard.visible = show


func set_score(kill_count: int, enemy_count: int):
	scoreboard.kill_count = kill_count
	scoreboard.enemy_count = enemy_count


func update_timer(seconds: float):
	scoreboard.update_timer_label(seconds)


func show_death_screen(show: bool = true):
	death_screen.visible = show


func show_level_end_screen(show: bool = true):
	level_end_screen.visible = show


func play_video(video: VideoStream, loop: bool = false):
	video_player.stream = video
	video_player.loop = loop
	video_player.show()
	video_player.play()
	
	await video_player.finished
	video_player.hide()


func stop_video():
	video_player.stop()
	video_player.hide()


func fade_screen(duration: float, fade_in: bool = false):
	screen_cover.show()
	var start_alpha = 1 if fade_in else 0
	var end_alpha = 0 if fade_in else 1
	
	screen_cover.modulate = Color(1, 1, 1, start_alpha)
	var tween = create_tween()
	tween.tween_property(screen_cover, "modulate:a", end_alpha, duration).from_current()
	await tween.finished
	if fade_in: screen_cover.hide()


func show_settings(show: bool = true):
	settings.visible = show


func show_credits(show: bool = true):
	SoundPlayer.play_music(load("res://assets/music/uh.ogg"))
	credits.visible = show
