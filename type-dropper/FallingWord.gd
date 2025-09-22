extends Node2D

@export var speed: float = 80
var word: String = ""
var typed_length: int = 0

var label: RichTextLabel

func _ready():
	label = RichTextLabel.new()
	label.bbcode_enabled = false
	label.text = word
	label.custom_minimum_size = Vector2(200, 30)
	label.scroll_active = false
	add_child(label)

func _process(delta):
	position.y += speed * delta

	if position.y > 600:
		if get_parent().has_method("decrease_life"):
			get_parent().decrease_life()
		queue_free()

func check_word(input_text: String) -> bool:
	typed_length = 0
	for i in range(min(input_text.length(), word.length())):
		if input_text[i] == word[i].to_lower():
			typed_length += 1
		else:
			break
	
	update_label_color()
	
	if typed_length == word.length() and input_text.length() >= word.length():
		queue_free()
		return true
	return false

func update_label_color():
	var correct = word.substr(0, typed_length)
	var remaining = word.substr(typed_length, word.length() - typed_length)
	label.bbcode_text = "[color=green]%s[/color]%s" % [correct, remaining]
