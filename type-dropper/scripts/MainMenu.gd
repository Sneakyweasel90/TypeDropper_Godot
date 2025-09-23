extends Control

@export var game_scene: PackedScene
@export var leaderboard_scene: PackedScene

func _ready():
	$VBoxContainer/EasyBtn.pressed.connect(start_game.bind("easy"))
	$VBoxContainer/MediumBtn.pressed.connect(start_game.bind("medium"))
	$VBoxContainer/HardBtn.pressed.connect(start_game.bind("hard"))
	
	$VBoxContainer/LeaderboardBtn.pressed.connect(show_leaderboard)

func start_game(difficulty: String) -> void:
	var scene = game_scene.instantiate()
	get_tree().root.add_child(scene)
	scene.setup(difficulty)
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = scene

func show_leaderboard() -> void:
	if leaderboard_scene:
		var scene = leaderboard_scene.instantiate()
		get_tree().root.add_child(scene)
		if get_tree().current_scene:
			get_tree().current_scene.queue_free()
		get_tree().current_scene = scene
