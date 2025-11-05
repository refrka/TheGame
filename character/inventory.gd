class_name Inventory extends Node

signal inventory_unlocked

var unlocked:= false
var item_list: Array


func add_item(item_data: ItemData) -> void:
	if !unlocked:
		unlocked = true
		inventory_unlocked.emit()