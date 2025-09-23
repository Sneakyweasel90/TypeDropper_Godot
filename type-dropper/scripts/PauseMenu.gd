extends Control

func _ready():
	visible = false

func _on_continue_btn_pressed() -> void:
	#print("Continue button pressed?") @debug
	visible = false
	get_tree().paused = false

func _on_main_menu_btn_pressed() -> void:
	#print("Main menu button pressed?") @debug
	get_tree().paused = false
	var main_menu = load("res://scenes/MainMenu.tscn").instantiate()
	get_tree().root.add_child(main_menu)
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = main_menu


func _on_sound_slider_value_changed(value: float) -> void:
	#slider for sound level
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
