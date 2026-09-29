extends Control

var ability_data: Dictionary


func setup(data: Dictionary):
	ability_data = data
	update_card()


func update_card():

	$Name.text = ability_data["name"]

	$Description.text = ability_data["description"]

	var image_path = ability_data["image"]

	if ResourceLoader.exists(image_path):
		$Icon.texture = load(image_path)
