extends Node2D

@export var speed: float
var word: String = ""
var typed_length: int = 0
var wrong_index: int = -1

@onready var label: RichTextLabel = $FallingWordsRichLabel

func _ready():
	label.bbcode_enabled = true
	label.text = word
	label.scroll_active = false

func _process(delta):
	position.y += speed * delta
	var parent_node = get_parent()

	if position.y > 648:
		if parent_node.has_method("decrease_life"):
			parent_node.decrease_life()
		queue_free()
		
		if parent_node.current_word == self:
			parent_node.current_word = null
			parent_node.current_input = ""
			
			if parent_node.has_node("InputLabel"):
				parent_node.get_node("InputLabel").text = ""
			
			parent_node.spawn_word()

func check_word(input_text: String) -> bool:
	typed_length = 0

	for i in range(min(input_text.length(), word.length())):
		if input_text[i].to_lower() == word[i].to_lower():
			typed_length += 1

	update_label_color()

	if typed_length == word.length() and input_text.length() >= word.length():
		queue_free()
		return true

	return false

func update_label_color():
	var bbcode := ""

	for i in range(word.length()):
		var letter = word[i]
		var color = "white"

		if i < typed_length:
			color = "green"
		elif i < get_parent().current_input.length():
			color = "red"

		bbcode += "[color=%s]%s[/color]" % [color, letter]

	label.bbcode_text = bbcode
