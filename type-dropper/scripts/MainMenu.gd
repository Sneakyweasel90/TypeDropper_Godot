extends Control

@export var game_scene: PackedScene
@onready var classic_modes = $VBoxContainer/ClassicBtn/VBoxContainer

func _ready():
	classic_modes.visible = false

func start_game(difficulty: String):
	var scene = game_scene.instantiate()
	get_tree().root.add_child(scene)
	scene.setup(difficulty)
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = scene

func _on_classic_btn_pressed() -> void:
	classic_modes.visible = !classic_modes.visible

func _on_difficulty_btn_pressed(difficulty: String) -> void:
	start_game(difficulty)
