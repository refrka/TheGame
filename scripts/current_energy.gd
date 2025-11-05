extends Label


func _ready() -> void:
	GameStateHandler.character_started.connect(_on_character_started)



func _on_character_started() -> void:
	GameStateHandler.character.current_energy_changed.connect(_on_current_energy_changed)



func _on_current_energy_changed() -> void:
	text = str(GameStateHandler.character.current_energy)