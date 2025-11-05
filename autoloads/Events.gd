extends Node


var subscriptions = {}


func subscribe(event_name: String, callback: Callable) -> void:
	if !subscriptions.has(event_name):
		subscriptions[event_name] = []
	if !subscriptions[event_name].has(callback):
		subscriptions[event_name].append(callback)


func publish (event: Dictionary) -> void:
	for callback in subscriptions[event["event_name"]]:
		if callback.is_valid():
			callback.call(event["data"])