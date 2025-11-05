extends MarginContainer


func _ready() -> void:
	visible = false
	GameStateHandler.character_started.connect(_on_character_started)


func _on_character_started() -> void:
	visible = true