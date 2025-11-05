class_name LocationData extends Resource


var id: int
var entered:= false
@export var location_name: String
@export var location_key: Enums.LOCATION
@export var location_tags: Array[Enums.LOCATION_TAG]
@export var location_pool: Array[Enums.LOCATION]
@export var forage_pool: Array[Enums.FORAGE]
@export var fauna_pool: Array[Enums.FAUNA]



var child_locations: Array[LocationData]