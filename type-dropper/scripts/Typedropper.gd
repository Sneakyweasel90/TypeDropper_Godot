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

func _ready():
	# Hide labels initially
	if $GameOverLabel:
		$GameOverLabel.visible = false
	if $InputLabel:
		$InputLabel.text = ""
	
	# Pause menu
	if pause_menu_scene:
		pause_menu = pause_menu_scene.instantiate()
		add_child(pause_menu)
		pause_menu.visible = false

	# Load words
	load_words("res://words/%s.txt" % difficulty)

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
	var path = "res://words/%s.txt" % difficulty
	load_words(path)

func _on_countdown_finished():
	print("Countdown finished signal received")
	game_running = true
	$SpawnTimer.start()
	spawn_word()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == Key.KEY_ESCAPE and pause_menu:
			pause_menu.visible = not pause_menu.visible
			get_tree().paused = pause_menu.visible
			if pause_menu.visible:
				pause_menu.move_to_front()  # menu is on top
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

func load_words(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		print("Failed to open file:", path)
		return
	words = []
	for w in file.get_as_text().split(",", false):
		var cleaned = w.strip_edges().replace('"', '')
		if cleaned != "":
			words.append(cleaned)
	file.close()

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
	get_tree().root.add_child(game_over_scene)

	# Free current game scene
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	get_tree().current_scene = game_over_scene
