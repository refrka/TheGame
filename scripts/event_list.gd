extends VBoxContainer


var skill_results_panel = preload("res://scenes/skill_results_panel.tscn")



func _ready() -> void:
	Events.subscribe("forage_results", _on_forage_results)
	Events.subscribe("hunting_results", _on_hunting_results)



func _on_forage_results(event_data: Dictionary) -> void:
	var results_panel = skill_results_panel.instantiate()
	var results = event_data["results"]
	results_panel.load_forage_results(results)
	add_child(results_panel)


func _on_hunting_results(event_data: Dictionary) -> void:
	var results_panel = skill_results_panel.instantiate()
	var results = event_data["results"]
	results_panel.load_hunting_results(results)
	add_child(results_panel)