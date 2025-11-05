extends Label

func _ready() -> void:
	GameStateHandler.character_started.connect(_on_character_started)


func _on_character_started() -> void:
	update_text(GameStateHandler.character.name)


func update_text(new_text: String) -> void:
	text = new_text
	if text.length() >= 14:
		add_theme_font_size_override("font_size", 12)