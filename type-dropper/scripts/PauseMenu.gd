extends CanvasLayer

@onready var sound_slider = $PauseMenu/VBoxContainer/MusicLevel/SoundSlider
var config_file_path := "user://settings.cfg"

func _ready():
	visible = false
	
	#load the saved volume
	var config = ConfigFile.new()
	if config.load(config_file_path) == OK:
		var saved_volume = config.get_value("audio", "volume_db", 20)
		sound_slider.value = saved_volume
		_apply_volume(saved_volume)
	else:
		sound_slider.value = 0
		_apply_volume(0)
	
func _on_continue_btn_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_main_menu_btn_pressed() -> void:
	get_tree().paused = false
	var main_menu = load("res://scenes/MainMenu.tscn").instantiate()
	get_tree().root.add_child(main_menu)
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = main_menu

func _on_sound_slider_value_changed(value: float) -> void:
	_apply_volume(value)
	
	# Save to config
	var config = ConfigFile.new()
	config.load(config_file_path)
	config.set_value("audio", "volume_db", value)
	config.save(config_file_path)

func _apply_volume(value: float) -> void:
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus, value)
	AudioServer.set_bus_mute(master_bus, value <= -30)
