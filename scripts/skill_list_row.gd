extends PanelContainer


signal skill_selected

var skill_name: String

func _ready() -> void:
	_connect_hover()
	_connect_gui_input()



func load_skill(skill_data: SkillData) -> void:
	skill_name = skill_data.skill_name
	%SkillName.text = skill_name
	%SkillValue.text = "%.2f" % skill_data.skill_value
	Events.subscribe("%s_updated" % skill_data.skill_name, _on_skill_updated)


func deselect() -> void:
	remove_theme_stylebox_override("panel")
	_connect_hover()



func _on_skill_updated(event_data: Dictionary) -> void:
	var new_value = event_data["new_value"]
	%SkillValue.text = "%.2f" % new_value


func _connect_hover() -> void:
	if !mouse_entered.has_connections():
		mouse_entered.connect(_on_mouse_entered)
	if !mouse_exited.has_connections():
		mouse_exited.connect(_on_mouse_exited)


func _connect_gui_input() -> void:
	if !gui_input.has_connections():
		gui_input.connect(_on_gui_input)


func _disconnect_hover() -> void:
	if mouse_entered.has_connections():
		mouse_entered.disconnect(_on_mouse_entered)
	if mouse_exited.has_connections():
		mouse_exited.disconnect(_on_mouse_exited)



func _on_mouse_entered() -> void:
	var stylebox = get_theme_stylebox("panel").duplicate()
	stylebox.border_color = Color.WHITE
	add_theme_stylebox_override("panel", stylebox)



func _on_mouse_exited() -> void:
	remove_theme_stylebox_override("panel")


func _on_gui_input(input: InputEvent) -> void:
	if input.is_action_pressed("select"):
		_disconnect_hover()
		skill_selected.emit()