extends Control

@export var final_score: int = 0
@export var top_score: int = 0

func _ready():
	$ScoreLabel.text = "Your Score: %d" % final_score
	$TopScoreLabel.text = "Top Score: %d" % top_score

func _on_retry_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://TypeDropper.tscn")

func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")
