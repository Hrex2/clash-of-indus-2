extends Control


signal hero_selected(hero_data)


# =========================================================
# UI
# =========================================================

@onready var hero_image = $HeroImage
@onready var hero_name = $HeroName

@onready var hp_label = $Stats/HPLabel
@onready var attack_label = $Stats/AttackLabel

@onready var ability_name = $AbilityName
@onready var ability_description = $AbilityDescription

@onready var rarity_label = $RarityLabel
@onready var level_label = $LevelLabel


# =========================================================
# DATA
# =========================================================

var hero_data: Dictionary = {}


# =========================================================
# SETUP
# =========================================================

func setup_hero(data: Dictionary):

	hero_data = data.duplicate(true)


	print(
		"SETUP HERO CALLED: ",
		hero_data
	)


	# -----------------------------------------------------
	# Image
	# -----------------------------------------------------

	if ResourceLoader.exists(hero_data["image"]):

		hero_image.texture = load(
			hero_data["image"]
		)


	# -----------------------------------------------------
	# Basic information
	# -----------------------------------------------------

	hero_name.text = hero_data["name"]

	hp_label.text = (
		"♥ "
		+ str(hero_data["hp"])
	)

	attack_label.text = (
		"⚔ "
		+ str(hero_data["attack"])
	)

	rarity_label.text = hero_data["rarity"]

	level_label.text = (
		"LV."
		+ str(hero_data["level"])
	)


	# -----------------------------------------------------
	# Ability
	# -----------------------------------------------------

	ability_name.text = hero_data["ability_name"]

	ability_description.text = \
		hero_data["ability_description"]


# =========================================================
# CARD CLICK
# =========================================================

func _on_click_area_pressed():

	if hero_data.is_empty():
		return


	print("================================")
	print("CARD CLICK")
	print("THIS CARD NODE: ", name)
	print("HERO: ", hero_data["name"])
	print("================================")


	hero_selected.emit(hero_data)
