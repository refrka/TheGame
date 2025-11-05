extends Button


func _ready() -> void:
	visible = false
	GameStateHandler.character_started.connect(_on_character_started)


func _on_character_started() -> void:
	GameStateHandler.character.inventory.inventory_unlocked.connect(_on_inventory_unlocked)


func _on_inventory_unlocked() -> void:
	visible = true