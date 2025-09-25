extends Control

@export var classic_scene: PackedScene
@export var rapid_scene: PackedScene
@onready var classic_modes = $VBoxContainer/ClassicModeBtn/ClassicModeContainer
@onready var rapid_modes = $VBoxContainer/SingleModeBtn/SingleModeContainer

func _ready():
	classic_modes.visible = false
	rapid_modes.visible = false

#click off the menu
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if classic_modes.visible and not classic_modes.get_global_rect().has_point(get_viewport().get_mouse_position()):
			classic_modes.visible = false
		if rapid_modes.visible and not rapid_modes.get_global_rect().has_point(get_viewport().get_mouse_position()):
			rapid_modes.visible = false

func start_game_classic(classicDifficulty: String):
	var scene = classic_scene.instantiate()
	get_tree().root.add_child(scene)
	scene.setup(classicDifficulty)
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = scene
	
func start_game_rapid(rapidDifficulty: String):
	var scene = rapid_scene.instantiate()
	get_tree().root.add_child(scene)
	scene.setup(rapidDifficulty)
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = scene

func _on_classic_btn_pressed() -> void:
	classic_modes.visible = !classic_modes.visible
	rapid_modes.visible = false

func _on_classic_difficulty_btn_pressed(classicDifficulty: String) -> void:
	start_game_classic(classicDifficulty)

func _on_rapid_mode_btn_pressed() -> void:
	rapid_modes.visible = !rapid_modes.visible
	classic_modes.visible = false

func _on_rapid_btn_pressed(rapidDifficulty: String) -> void:
	start_game_rapid(rapidDifficulty)
