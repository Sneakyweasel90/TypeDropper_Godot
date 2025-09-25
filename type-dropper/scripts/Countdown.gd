extends CanvasLayer
signal countdown_finished

@export var start_value: int = 3
var current_value: int

func _ready():
	current_value = start_value
	$CanvasLayer/Label.text = str(current_value)
	$Timer.start()

func _on_timer_timeout():
	current_value -= 1
	if current_value > 0:
		$CanvasLayer/Label.text = str(current_value)
	else:
		$Timer.stop()
		$CanvasLayer/Label.text = "Go!"
		await get_tree().create_timer(1).timeout
		emit_signal("countdown_finished")
		queue_free()
