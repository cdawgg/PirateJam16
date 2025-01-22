extends CanvasLayer

@onready var main_menu: MainMenu = $MainMenu
@onready var scoreboard: Scoreboard = $Scoreboard
@onready var death_screen: Control = $DeathScreen


func _ready():
	main_menu.show()
	scoreboard.hide()
	death_screen.hide()


func show_main_menu(show: bool = true):
	main_menu.visible = show


func show_scoreboard(show: bool = true):
	scoreboard.visible = show


func set_score(kill_count: int, enemy_count: int):
	scoreboard.kill_count = kill_count
	scoreboard.enemy_count = enemy_count


func show_death_screen(show: bool = true):
	death_screen.visible = show
