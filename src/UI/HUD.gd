extends CanvasLayer

signal start_game


onready var score_label: Label = $ScoreLabel
onready var message: Label = $Message
onready var start_button: Button = $StartButton
onready var message_timer: Timer = $MessageTimer


func show_message(text: String) -> void:
	message.text = text
	message.show()
	message_timer.start()


func show_game_over():
	show_message("Game Over")
	
	# 타이머 대기
	yield(message_timer, "timeout")
	
	message.text = "Dodge the\nCreeps!"
	message.show()
	
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	start_button.show()


func update_score(score: int) -> void:
	score_label.text = str(score)


func _on_StartButton_pressed() -> void:
	start_button.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout() -> void:
	message.hide()
