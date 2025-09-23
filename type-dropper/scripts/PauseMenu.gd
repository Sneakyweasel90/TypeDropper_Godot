extends Control

func _ready():
	visible = false
	$VBoxContainer/ContinueBtn.pressed.connect(_on_continue_pressed)
	$VBoxContainer/MainMenuBtn.pressed.connect(_on_main_menu_pressed)
	
func _on_continue_pressed():
	visible = false
	get_tree().paused = false

func _on_main_menu_pressed():
	get_tree().paused = false
	var main_menu = load("res://MainMenu.tscn").instantiate()
	get_tree().root.add_child(main_menu)
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = main_menu
