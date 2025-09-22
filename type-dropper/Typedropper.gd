extends Node2D

@export var word_scene: PackedScene

var score: int = 0
var lives: int = 3
var words: Array = []
var difficulty: String = "easy"
var current_input: String = ""

func _ready():
	var path = "res://words/%s.txt" % difficulty
	load_words(path)

	$SpawnTimer.timeout.connect(spawn_word)
	$SpawnTimer.start()

	if $GameOverLabel:
		$GameOverLabel.visible = false

	if $InputLabel:
		$InputLabel.text = ""

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
		var cleaned = w.strip_edges()
		cleaned = cleaned.replace('"', '')
		if cleaned != "":
			words.append(cleaned)
		
	print("Loaded words:", words)

func _input(event):
	if event is InputEventKey and event.pressed and event.unicode != 0:
		var typed_char = char(event.unicode).to_lower()

		current_input += typed_char
		if $InputLabel:
			$InputLabel.text = current_input

		for child in get_children():
			if child.has_method("check_word") and child.check_word(current_input):
				score += 1
				current_input = ""
				if $InputLabel:
					$InputLabel.text = ""
				break

		if current_input.length() > 15:
			current_input = ""
			if $InputLabel:
				$InputLabel.text = ""


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
	var word = words[randi() % words.size()]
	word_instance.word = word
	var x = randf_range(50, 550)
	word_instance.position = Vector2(x, 0)
	add_child(word_instance)


func game_over():
	$SpawnTimer.stop()
	set_process(false)

	if $GameOverLabel:
		$GameOverLabel.text = "Game Over!\nScore: %d" % score
		$GameOverLabel.visible = true
