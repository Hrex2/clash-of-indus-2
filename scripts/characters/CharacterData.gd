extends Node


# =========================================================
# CHARACTER ANIMATION DATA
# =========================================================

var characters = {

	# =====================================================
	# FIRE KEEPER
	# =====================================================

	"fire_keeper": {
		"name": "FIRE KEEPER",
		"front": "res://data/characters/fire_keeper_front.tres",
		"back": "res://data/characters/fire_keeper_back.tres"
	},


	# =====================================================
	# NEANDERTHAL HUNTER
	# =====================================================

	"neanderthal": {
		"name": "NEANDERTHAL HUNTER",
		"front": "res://data/characters/neanderthal_front.tres",
		"back": "res://data/characters/neanderthal_back.tres"
	},


	# =====================================================
	# CAVE GUARDIAN
	# =====================================================

	"cave_guardian": {
		"name": "CAVE GUARDIAN",
		"front": "res://data/characters/cave_guardian_front.tres",
		"back": "res://data/characters/cave_guardian_back.tres"
	},


	# =====================================================
	# TRIBAL SPEARMAN
	# =====================================================

	"tribal_spearman": {
		"name": "TRIBAL SPEARMAN",
		"front": "res://data/characters/tribal_spearman_front.tres",
		"back": "res://data/characters/tribal_spearman_back.tres"
	},


	# =====================================================
	# CAVE STALKER
	# =====================================================

	"cave_stalker": {
		"name": "CAVE STALKER",
		"front": "res://data/characters/cave_stalker_front.tres",
		"back": "res://data/characters/cave_stalker_back.tres"
	},


	# =====================================================
	# MAMMOTH RIDER
	# =====================================================

	"mammoth_rider": {
		"name": "MAMMOTH RIDER",
		"front": "res://data/characters/mammoth_rider_front.tres",
		"back": "res://data/characters/mammoth_rider_back.tres"
	}
}


# =========================================================
# GET CHARACTER
# =========================================================

func get_character(character_id: String) -> Dictionary:

	if characters.has(character_id):

		return characters[character_id]


	push_error(
		"Character not found: " + character_id
	)

	return {}
