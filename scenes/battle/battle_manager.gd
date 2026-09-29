extends Node


# =========================================================
# DATA
# =========================================================

var hero_data = preload(
	"res://scripts/HeroDate.gd"
).new()

var ability_data = preload(
	"res://scripts/abilityData.gd"
).new()


# =========================================================
# CHARACTER MANAGER
# =========================================================

@onready var character_manager = $"../CharacterManager"


# =========================================================
# TEAMS
# =========================================================

var player_heroes: Array = []
var enemy_heroes: Array = []

var player_abilities: Array = []
var enemy_abilities: Array = []


# =========================================================
# READY
# =========================================================

func _ready():

	print("================================")
	print("BATTLE MANAGER READY")
	print("================================")

	start_battle()


# =========================================================
# START BATTLE
# =========================================================

func start_battle():

	player_heroes.clear()
	enemy_heroes.clear()

	player_abilities.clear()
	enemy_abilities.clear()


	# =====================================================
	# PLAYER HEROES
	# =====================================================

	var heroes: Array = \
		hero_data.prehistoric_heroes.duplicate(true)

	heroes.shuffle()

	player_heroes = heroes.slice(0, 3)


	# =====================================================
	# ENEMY HEROES
	# =====================================================

	var enemy_pool: Array = \
		hero_data.prehistoric_heroes.duplicate(true)

	enemy_pool.shuffle()

	enemy_heroes = enemy_pool.slice(0, 3)


	# =====================================================
	# PLAYER ABILITIES
	# =====================================================

	var abilities: Array = \
		ability_data.abilities.duplicate(true)

	abilities.shuffle()

	player_abilities = abilities.slice(0, 3)


	# =====================================================
	# ENEMY ABILITIES
	# =====================================================

	var enemy_ability_pool: Array = \
		ability_data.abilities.duplicate(true)

	enemy_ability_pool.shuffle()

	enemy_abilities = enemy_ability_pool.slice(0, 3)


	# =====================================================
	# PRINT BATTLE DATA
	# =====================================================

	print("================================")
	print("BATTLE START")
	print("================================")

	print("")
	print("========== PLAYER ==========")

	print("")
	print("HERO CARDS:")

	for hero in player_heroes:

		print(
			" - ",
			hero["name"],
			" | Animation: ",
			hero["animation_id"],
			" | HP: ",
			hero["hp"],
			" | ATK: ",
			hero["attack"]
		)


	print("")
	print("ABILITY CARDS:")

	for ability in player_abilities:

		print(
			" - ",
			ability["name"],
			" | Type: ",
			ability["type"],
			" | Power: ",
			ability["power"]
		)


	print("")
	print("========== ENEMY ==========")

	print("")
	print("HIDDEN HERO CARDS:")

	for hero in enemy_heroes:

		print(
			" - ",
			hero["name"],
			" | Animation: ",
			hero["animation_id"]
		)


	print("")
	print("HIDDEN ABILITY CARDS:")

	for ability in enemy_abilities:

		print(
			" - ",
			ability["name"]
		)


	print("================================")


	# =====================================================
	# SETUP BATTLEFIELD
	# =====================================================

	setup_battlefield()


# =========================================================
# SETUP BATTLEFIELD
# =========================================================

func setup_battlefield():

	print("")
	print("================================")
	print("SETTING UP BATTLEFIELD")
	print("================================")


	if character_manager == null:

		push_error(
			"CharacterManager not found!"
		)

		return


	# =====================================================
	# CREATE ALL CHARACTERS
	# =====================================================

	character_manager.setup_characters(
		player_heroes,
		enemy_heroes,
		$"../Battlefield"
	)


	print("================================")
	print("BATTLE DATA READY")
	print("================================")
