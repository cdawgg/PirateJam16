extends HSlider

@export var bus_name: String
var bus_index: int


func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	
	value_changed.connect(_on_value_changed)


func _on_value_changed(val: float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(val))
	if bus_name == "SFX":
		SoundPlayer.play_sound(load("res://assets/sfx/boulder/jump.wav"))
