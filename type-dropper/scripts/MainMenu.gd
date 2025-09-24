extends Control

@export var game_scene: PackedScene

func _ready():
	$VBoxContainer/EasyBtn.pressed.connect(start_game.bind("easy"))
	$VBoxContainer/MediumBtn.pressed.connect(start_game.bind("medium"))
	$VBoxContainer/HardBtn.pressed.connect(start_game.bind("hard"))

func start_game(difficulty: String):
	var scene = game_scene.instantiate()
	get_tree().root.add_child(scene)
	scene.setup(difficulty)
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = scene
