extends HBoxContainer



func _ready() -> void:
	visible = false
	GameStateHandler.character_started.connect(_on_character_started)
	%ForageButton.pressed.connect(_on_forage_pressed)
	%HuntButton.pressed.connect(_on_hunt_pressed)
	%SeekShelterButton.pressed.connect(_on_seek_shelter_pressed)


func _on_character_started() -> void:
	visible = true


func _on_forage_pressed() -> void:
	GameStateHandler.character.add_skill("Foraging")
	GameStateHandler.character.execute_skill("Foraging")


func _on_hunt_pressed() -> void:
	GameStateHandler.character.add_skill("Hunting")
	GameStateHandler.character.execute_skill("Hunting")


func _on_seek_shelter_pressed() -> void:
	pass