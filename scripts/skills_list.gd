extends VBoxContainer


signal skill_selected


const skill_row = preload("res://scenes/skill_list_row.tscn")


func _ready() -> void:
	visible = false
	Events.subscribe("add_skill", _on_add_skill_event)




func _on_add_skill_event(event_data: Dictionary) -> void:
	visible = true
	var skill_data = event_data["skill_data"]
	var row = skill_row.instantiate()
	row.load_skill(skill_data)
	row.skill_selected.connect(_on_skill_selected.bind(row, skill_data.skill_name))
	add_child(row)



func _on_skill_selected(selected_row: PanelContainer, skill_name: String) -> void:
	for row in get_children():
		if row != selected_row:
			row.deselect()
	skill_selected.emit(skill_name)