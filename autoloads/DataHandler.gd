extends Node


var item_rarity_weights:= {
	"common": 0.7,
	"uncommon": 0.3,
	"rare": 0.08,
	"unique": 0.01,
}



func get_location_data(location: Enums.LOCATION) -> LocationData:
	var location_name = Enums.LOCATION.keys()[location].to_snake_case()
	return load("res://data/location_data/%s.tres" % location_name)


func get_forage_data(forage: Enums.FORAGE) -> ForageData:
	var forage_name = Enums.FORAGE.keys()[forage].to_snake_case()
	return load("res://data/item_data/forage_data/%s.tres" % forage_name)


func get_animal_parts_data(animal_parts: Enums.ANIMAL_PARTS) -> AnimalPartsData:
	var animal_parts_name = Enums.ANIMAL_PARTS.keys()[animal_parts].to_snake_case()
	return load("res://data/item_data/animal_parts_data/%s.tres" % animal_parts_name)



func get_fauna_data(fauna: Enums.FAUNA) -> FaunaData:
	var fauna_name = Enums.FAUNA.keys()[fauna].to_snake_case()
	return load("res://data/entity_data/%s.tres" % fauna_name)



func get_location_forage(location_data: LocationData) -> Array:
	var forage = []
	for item in location_data.forage_pool:
		var forage_data = get_forage_data(item)
		forage.append(forage_data)
	return forage


func get_location_fauna(location_data: LocationData) -> Array:
	var fauna = []
	for entity in location_data.fauna_pool:
		var fauna_data = get_fauna_data(entity)
		fauna.append(fauna_data)
	return fauna
