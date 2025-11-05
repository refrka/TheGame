extends PanelContainer

var hunting_button_group:= ButtonGroup.new()

var selected_entities: Array
var selected_items: Array


func _ready() -> void:
	hunting_button_group.allow_unpress = true
	%ActionButton.disabled = true
	%DismissButton.pressed.connect(_on_dismiss_pressed)



func load_forage_results(results: Array) -> void:
	for result in results:
		var button = Button.new()
		button.text = result.item_name
		button.toggle_mode = true
		%ResultsBox.add_child(button)
		%ResultsTitle.text = "Results from foraging:"
		%ActionButton.text = "Collect"
		button.toggled.connect(_on_forage_button_toggled.bind(result))
	%ActionButton.pressed.connect(_on_collect_forage_pressed)



func load_hunting_results(results: Array) -> void:
	for result in results:
		var button = Button.new()
		button.text = result.entity_name
		button.button_group = hunting_button_group
		button.toggle_mode = true
		%ResultsBox.add_child(button)
		%ResultsTitle.text = "Results from hunting:"
		%ActionButton.text = "Attack"
		button.toggled.connect(_on_hunting_button_toggled.bind(result))
	%ActionButton.pressed.connect(_on_attack_pressed)
	
	

func _on_forage_button_toggled(state: bool, result: ForageData) -> void:
	if state == true:
		%ActionButton.disabled = false
		selected_items.append(result)
	else:
		selected_items.erase(result)
		for button in %ResultsBox.get_children():
			if button.button_pressed == true:
				%ActionButton.disabled = false
				return
		%ActionButton.disabled = true


func _on_hunting_button_toggled(state: bool, result: FaunaData) -> void:
	if state == true:
		%ActionButton.disabled = false
		selected_entities.append(result)
	else:
		selected_entities.erase(result)
		if hunting_button_group.get_pressed_button() == null:
			%ActionButton.disabled = true
		else:
			%ActionButton.disabled = false


func _on_dismiss_pressed() -> void:
	queue_free()


func _on_attack_pressed() -> void:
	pass


func _on_collect_forage_pressed() -> void:
	var count = {}
	for item in selected_items:
		if !count.has(item.forage_key):
			count[item.forage_key] = 0
		count[item.forage_key] += 1
		GameStateHandler.character.inventory.add_item(item)
	for button in %ResultsBox.get_children():
		if button.button_pressed == true:
			%ResultsBox.remove_child(button)
			button.queue_free()
	if %ResultsBox.get_children().size() == 0:
		queue_free()
	else:
		%ActionButton.disabled = true
	var count_line = ""
	var i = selected_items.size()
	var n = 0
	for key in count:
		n += 1
		var data = DataHandler.get_forage_data(key)
		count_line += "%s (x%s)" % [data.item_name, count[key]]
		if n != i:
			count_line += ", "
	var event = {
		"event_name": "quick_desc",
		"data": {
			"desc": "Collected %s item(s): %s" % [i, count_line]
		}
	}
	Events.publish(event)