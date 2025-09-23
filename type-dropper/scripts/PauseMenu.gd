extends Control

func _ready():
	visible = false

func _on_continue_btn_pressed() -> void:
	print("Continue button pressed?")
	visible = false
	get_tree().paused = false

func _on_main_menu_btn_pressed() -> void:
	print("Main menu button pressed?")
	get_tree().paused = false
	var main_menu = load("res://scenes/MainMenu.tscn").instantiate()
	get_tree().root.add_child(main_menu)
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = main_menu
