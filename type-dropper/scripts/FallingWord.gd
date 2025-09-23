extends Node2D

@export var speed: float
var word: String = ""
var typed_length: int = 0
var wrong_index: int = -1
var label: RichTextLabel

func _ready():
	label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.text = word
	label.custom_minimum_size = Vector2(200, 30)
	label.scroll_active = false
	add_child(label)

func _process(delta):
	position.y += speed * delta
	var parent_node = get_parent()

	if position.y > 600:
		if get_parent().has_method("decrease_life"):
			get_parent().decrease_life()
		queue_free()
		if get_parent().current_word == self:
			get_parent().current_word = null
			get_parent().current_input = ""
			if parent_node.has_node("InputLabel"):
				parent_node.get_node("InputLabel").text = ""
			get_parent().spawn_word()

func check_word(input_text: String) -> bool:
	typed_length = 0
	wrong_index = -1

	for i in range(min(input_text.length(), word.length())):
		if input_text[i] == word[i].to_lower():
			typed_length += 1
		else:
			wrong_index = i
			break

	update_label_color()

	if typed_length == word.length() and input_text.length() >= word.length():
		queue_free()
		return true
	return false

func update_label_color():
	var correct_text = word.substr(0, typed_length)
	var wrong_text = ""
	var remaining_text = ""

	if wrong_index >= 0:
		wrong_text = word[wrong_index]
		if word.length() > wrong_index + 1:
			remaining_text = word.substr(wrong_index + 1, word.length() - wrong_index - 1)
	else:
		if word.length() > typed_length:
			remaining_text = word.substr(typed_length, word.length() - typed_length)

	label.bbcode_text = "[color=green]%s[/color][color=red]%s[/color][color=white]%s[/color]" % [correct_text, wrong_text, remaining_text]
