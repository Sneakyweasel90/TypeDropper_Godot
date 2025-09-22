extends Node2D

@export var word_scene: PackedScene
@export var difficulty: String = "easy"

var score: int = 0
var lives: int = 3
var words: Array = []
var current_input: String = ""
var word_speed = 80
var current_word: Node = null # Need to track the active word with this

func _ready():
	if $GameOverLabel:
		$GameOverLabel.visible = false
	if $InputLabel:
		$InputLabel.text = ""

	var path = "res://words/%s.txt" % difficulty
	load_words(path)
	spawn_word()

func setup(difficulty_choice: String):
	difficulty = difficulty_choice
	var path = "res://words/%s.txt" % difficulty
	load_words(path)
	$SpawnTimer.start()

func load_words(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		print("Failed to open file:", path)
		return
	
	var content = file.get_as_text()
	file.close()
	words.clear()

	var split_words = content.split(",", false)
	for w in split_words:
		var cleaned = w.strip_edges().replace('"', '')
		if cleaned != "":
			words.append(cleaned)

	#print("Loaded words:", words)

func _input(event):
	if not current_word:
		return
	
	if event is InputEventKey and event.is_pressed():
		if event.keycode == Key.KEY_BACKSPACE:
			if current_input.length() > 0:
				current_input = current_input.substr(0, current_input.length() - 1)
				if $InputLabel:
					$InputLabel.text = current_input
		elif event.unicode != 0:
			var typed_char = char(event.unicode).to_lower()
			current_input += typed_char
			if $InputLabel:
				$InputLabel.text = current_input
		
		if current_word.has_method("check_word") and current_word.check_word(current_input):
			score += 100
			word_speed += 2
			current_input = ""
			if $InputLabel:
				$InputLabel.text = ""
			current_word = null
			spawn_word()

func _process(_delta):
	if $ScoreLabel:
		$ScoreLabel.text = "Score: %d" % score
	if $LivesLabel:
		$LivesLabel.text = "Lives: %d" % lives

	if lives <= 0:
		game_over()

func spawn_word():
	if not word_scene or words.is_empty():
		return
	var word_instance = word_scene.instantiate()
	var word_text = words[randi() % words.size()]
	word_instance.word = word_text
	word_instance.speed = word_speed
	var x = randf_range(50, 550)
	word_instance.position = Vector2(x, 0)
	add_child(word_instance)
	current_word = word_instance

func game_over():
	$SpawnTimer.stop()
	set_process(false)
	if $GameOverLabel:
		$GameOverLabel.text = "Game Over!\nScore: %d" % score
		$GameOverLabel.visible = true

func decrease_life():
	lives -= 1
