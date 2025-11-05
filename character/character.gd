class_name Character extends Node


signal current_energy_changed


var level: int
var xp: int
var current_health:= 10
var max_health:= 20
var max_health_modifier:= -10
var current_energy:= 5
var max_energy:= 10
var max_energy_modifier:= -5



var current_location: LocationData







var skills: Dictionary



var inventory:= Inventory.new()







func add_skill(skill_name: String) -> void:
	if skills.has(skill_name):
		return
	var skill_data = load("res://data/skill_data/%s.tres" % skill_name.to_lower()).duplicate()
	skills[skill_name] = skill_data
	var event = {
		"event_name": "add_skill",
		"data": {
			"skill_data": skill_data,
		}
	}
	Events.publish(event)


func update_skill(skill_name: String, value_change: float) -> void:
	var skill_data = skills[skill_name]
	skill_data.skill_value += value_change
	var event = {
		"event_name": "%s_updated" % skill_name,
		"data": {
			"new_value": skill_data.skill_value,
		}
	}
	Events.publish(event)


func get_skill_value(skill_name: String) -> float:
	return skills[skill_name]


func get_skill_multiplier(skill_value: float) -> float:
	return 1.0 + (skill_value / (5.0 + skill_value))


func get_skill_result_count(skill_value: float) -> int:
	var base = 1
	var chance = 0.15 + skill_value  # 5% per skill level
	var count = base
	while randf() < chance / 20:
		count += 1
		chance *= 0.5  # decaying chance for more
	return count


func get_rarity_roll(skill_value: float) -> String:
	var bonus = clamp(skill_value * 0.02, 0, 0.5)  # up to +50% bias
	var weights = {
	"common": 0.6 - bonus * 0.3,
	"uncommon": 0.25 + bonus * 0.15,
	"rare": 0.1 + bonus * 0.1,
	"epic": 0.04 + bonus * 0.03,
	"unique": 0.01 + bonus * 0.01
	}
	var roll = randf()
	var cumulative = 0.0
	for rarity in weights.keys():
		cumulative += weights[rarity]
		if roll <= cumulative:
			return rarity
	return "common"


func get_skill_gain_from_results(results: Array) -> float:
	var gain = 0.02
	for result in results:
		match result.rarity:
			"common":
				gain += 0.01
			"uncommon":
				gain += 0.02
			"rare":
				gain += 0.03
			"epic":
				gain += 0.05
	return gain


func execute_skill(skill_name: String) -> void:
	var skill_data = skills[skill_name]
	if current_energy < skill_data.skill_energy_cost:
		var event = {
			"event_name": "quick_desc",
			"data": {
				"desc": "You don't have enough energy to perform this action.",
				"flash": Color.RED,
			}
		}
		Events.publish(event)
		return
	spend_energy(skill_data.skill_energy_cost)
	match skill_name:
		"Foraging":
			var location_forage = DataHandler.get_location_forage(current_location)
			var results = forage(skill_data.skill_value, location_forage)
			for item in results:
				print(item.item_name)
			var event = {
				"event_name": "quick_desc",
				"data": {
					"desc": "%s energy spent on %s. %s item(s) discovered." % [skill_data.skill_energy_cost, "foraging", results.size()]
				}
			}
			Events.publish(event)
		"Hunting":
			var location_fauna = DataHandler.get_location_fauna(current_location)
			var results = hunt(skill_data.skill_value, location_fauna)
			for entity in results:
				print(entity.entity_name)
			var event = {
				"event_name": "quick_desc",
				"data": {
					"desc": "%s energy spent on %s. %s entity(s) discovered." % [skill_data.skill_energy_cost, "hunting", results.size()]
				}
			}
			Events.publish(event)


func forage(raw_skill_value: float, forageables: Array) -> Array:
	var skill_value = get_skill_multiplier(raw_skill_value)
	var results = []
	var count = get_skill_result_count(skill_value)
	for i in count:
		var rarity = get_rarity_roll(skill_value)
		var pool = forageables.filter(func(f): return f.rarity == rarity)
		if pool.is_empty():
			pool = forageables.filter(func(f): return f.rarity == "common")
		results.append(pool.pick_random())
	var skill_gain = get_skill_gain_from_results(results)
	update_skill("Foraging", skill_gain)
	var event = {
		"event_name": "forage_results",
		"data": {
			"results": results,
		}
	}
	Events.publish(event)
	return results



func hunt(raw_skill_value: float, fauna: Array) -> Array:
	var skill_value = get_skill_multiplier(raw_skill_value)
	var results = []
	var count = get_skill_result_count(skill_value)
	for i in count:
		var rarity = get_rarity_roll(skill_value)
		var pool = fauna.filter(func(f): return f.rarity == rarity)
		if pool.is_empty():
			pool = fauna.filter(func(f): return f.rarity == "common")
		results.append(pool.pick_random())
	var skill_gain = get_skill_gain_from_results(results)
	update_skill("Hunting", skill_gain)
	var event = {
		"event_name": "hunting_results",
		"data": {
			"results": results,
		}
	}
	Events.publish(event)
	return results




func spend_energy(amount: int) -> void:
	current_energy -= amount
	current_energy_changed.emit()

