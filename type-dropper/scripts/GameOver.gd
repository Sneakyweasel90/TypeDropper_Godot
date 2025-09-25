extends Control

@export var final_score: int = 0
@export var top_score: int = 0

var previous_game_scene_path: String = ""

func _ready():
	$ScoreLabel.text = "Your Score: %d" % final_score
	#$TopScoreLabel.text = "Top Score: %d" % top_score #Used for later to grab leaderboard API

func _on_retry_btn_pressed() -> void:
	if GameState.last_game_scene_path != "":
		get_tree().change_scene_to_file(GameState.last_game_scene_path)
	else:
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
