extends Node2D

@export var speed: float = 100
var word: String = ""

func _ready():
	var label = Label.new()
	label.text = word
	label.name = "WordLabel"
	add_child(label)

func _process(delta):
	position.y += speed * delta

	if position.y > 600:
		if get_parent().has_variable("lives"):
			get_parent().lives -= 1
		queue_free()

func check_word(input_text: String) -> bool:
	if input_text == word.to_lower():
		queue_free()
		return true
	return false
