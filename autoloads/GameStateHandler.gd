extends Node


signal character_started


var character: Character


var locations: Array[LocationData]



func start_character(_name: String) -> void:
	character = Character.new()
	character.name = _name
	add_child(character)
	var location_data = DataHandler.get_location_data(Enums.LOCATION.FOREST)
	enter_location(location_data)
	character_started.emit()
	var event = {
		"event_name": "quick_desc",
		"data": {"desc": "You awake, cold and hungry, deep in the woods. It is daytime, but the forest is dark."}
	}
	Events.publish(event)



func enter_location(location_data: LocationData) -> void:
	if !locations.has(location_data):
		add_location(location_data)
	character.current_location = location_data
	location_data.entered = true



func add_location(location_data: LocationData) -> void:
	location_data.id = locations.size()
	locations.append(location_data)