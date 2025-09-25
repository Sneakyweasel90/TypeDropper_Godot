extends Control

@export var game_scene: PackedScene
@onready var classic_modes = $VBoxContainer/ClassicModeBtn/ClassicModeContainer
@onready var rapid_modes = $VBoxContainer/RapidModeBtn/RapidModeContainer

func _ready():
	classic_modes.visible = false
	rapid_modes.visible = false

func start_game(difficulty: String):
	var scene = game_scene.instantiate()
	get_tree().root.add_child(scene)
	scene.setup(difficulty)
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = scene

func _on_classic_btn_pressed() -> void:
	classic_modes.visible = !classic_modes.visible
	rapid_modes.visible = false

func _on_difficulty_btn_pressed(difficulty: String) -> void:
	start_game(difficulty)

#click off the menu
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if classic_modes.visible and not classic_modes.get_global_rect().has_point(get_viewport().get_mouse_position()):
			classic_modes.visible = false

func _on_rapid_mode_btn_pressed() -> void:
	rapid_modes.visible = !rapid_modes.visible
	classic_modes.visible = false
