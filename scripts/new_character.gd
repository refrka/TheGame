extends HBoxContainer




func _ready() -> void:
	visible = true
	%NewNameEntry.text_submitted.connect(_on_text_submitted)
	%NewNameSubmit.pressed.connect(_on_submit_pressed)


func _on_text_submitted(text: String) -> void:
	GameStateHandler.start_character(text)
	visible = false


func _on_submit_pressed() -> void:
	_on_text_submitted(%NewNameEntry.text)