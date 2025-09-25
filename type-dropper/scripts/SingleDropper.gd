extends Node2D

@export var word_scene: PackedScene
@export var difficulty: String = "easy"
@export var pause_menu_scene: PackedScene
@export var countdown_scene: PackedScene

var score: int = 0
var lives: int = 3
var words: Array = []
var current_input: String = ""
var word_speed = 300
var current_word: Node = null
var game_running: bool = false
var pause_menu: Node = null
var countdown: Node = null
var scene_path: String = ""

const EASY_CHARS = "abcdefghijklmnopqrstuvwxyz"
const MEDIUM_CHARS = "abcdefghijklmnopqrstuvwxyz0123456789"
const HARD_CHARS = "abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*?"

func _ready():
	if $GameOverLabel:
		$GameOverLabel.visible = false
	if $InputLabel:
		$InputLabel.text = ""
	
	if GameState.last_difficulty != "":
		setup(GameState.last_difficulty)
		print(GameState.last_difficulty)

	else:
		# fallback to default if nothing is set
		setup(difficulty)
	
	# Pause menu
	if pause_menu_scene:
		pause_menu = pause_menu_scene.instantiate()
		add_child(pause_menu)
		pause_menu.visible = false

	# Load words (now generates characters instead of reading files)
	generate_words()

	# Countdown
	if countdown_scene:
		print("Starting countdown scene")
		countdown = countdown_scene.instantiate()
		add_child(countdown)
		countdown.countdown_finished.connect(_on_countdown_finished)
	else:
		print("No countdown scene assigned")

func setup(difficulty_choice: String):
	difficulty = difficulty_choice
	generate_words()

func generate_words():
	words.clear()
	var pool = EASY_CHARS
	if difficulty.to_lower() == "medium":
		pool = MEDIUM_CHARS
	elif difficulty.to_lower() == "hard":
		pool = HARD_CHARS
	
	for i in range(100):
		words.append(pool[randi() % pool.length()])

func _on_countdown_finished():
	game_running = true
	$SpawnTimer.start()
	spawn_word()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == Key.KEY_ESCAPE and pause_menu:
			pause_menu.visible = not pause_menu.visible
			get_tree().paused = pause_menu.visible
			#if pause_menu.visible:
				#pause_menu.move_to_front()
			return

		if not game_running:
			return

		# Backspace
		if event.keycode == Key.KEY_BACKSPACE and current_input.length() > 0:
			current_input = current_input.substr(0, current_input.length() - 1)
			$InputLabel.text = current_input
		# Typing
		elif event.unicode != 0:
			current_input += char(event.unicode).to_lower()
			$InputLabel.text = current_input

		# Check word
		if current_word and current_word.has_method("check_word") and current_word.check_word(current_input):
			score += 100
			word_speed += 2
			current_input = ""
			$InputLabel.text = ""
			current_word = null
			spawn_word()

func _process(_delta):
	$ScoreLabel.text = "Score: %d" % score
	$LivesLabel.text = "Lives: %d" % lives
	$SpeedLabel.text = "Speed: %d" % word_speed

	if lives <= 0 and game_running:
		game_over()

func spawn_word():
	if not game_running or words.is_empty() or not word_scene:
		return
	var word_instance = word_scene.instantiate()
	word_instance.word = words[randi() % words.size()]
	word_instance.speed = word_speed
	word_instance.position = Vector2(randf_range(50, 1100), 0)
	add_child(word_instance)
	current_word = word_instance

func decrease_life():
	lives -= 1

func return_to_main_menu():
	$SpawnTimer.stop()
	var main_menu = load("res://scenes/MainMenu.tscn").instantiate()
	get_tree().root.add_child(main_menu)
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = main_menu

func game_over():
	game_running = false
	$SpawnTimer.stop()
	set_process(false)
	set_process_input(false)

	# Clear remaining words
	for child in get_children():
		if child is Node2D and child.has_method("check_word"):
			child.queue_free()

	# Load GameOver scene
	var game_over_scene = load("res://scenes/GameOver.tscn").instantiate()
	game_over_scene.final_score = score
	game_over_scene.previous_game_scene_path = scene_path
	get_tree().root.add_child(game_over_scene)

	# Free current game scene
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = game_over_scene
