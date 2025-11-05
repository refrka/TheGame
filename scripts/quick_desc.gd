extends Label


var font_color: Color:
	set(value):
		font_color = value
		add_theme_color_override("font_color", font_color)


func _ready() -> void:
	Events.subscribe("quick_desc", _on_quick_desc_event)


func _on_quick_desc_event(data: Dictionary) -> void:
	text = data["desc"]
	if data.has("flash"):
		font_color = data["flash"]
		var tween = get_tree().create_tween()
		tween.tween_property(self, "font_color", Color.WHITE, 0.6)
