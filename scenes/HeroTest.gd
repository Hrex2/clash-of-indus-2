extends Control

var hero_card_scene = preload("res://scenes/cards/hero_card.tscn")

func _ready():
	for hero in HeroData.prehistoric_heroes:
		var card = hero_card_scene.instantiate()
		$HeroGrid.add_child(card)
		card.setup_hero(hero)
