extends Control


@export var ability_card_scene: PackedScene

var ability_data = preload("res://scripts/abilityData.gd").new()


func _ready():

	for ability in ability_data.abilities:

		var card = ability_card_scene.instantiate()

		$AbilityContainer.add_child(card)

		card.setup(ability)
