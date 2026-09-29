extends Node


# =========================================================
# CHARACTER SCENE
# =========================================================

const CHARACTER_SCENE = preload(
	"res://scenes/characters/CharacterTest.tscn"
)


# =========================================================
# FIXED BATTLE POSITIONS
# =========================================================
#
# These positions are relative to Battlefield.
#
# Enemy = upper row
# Player = lower row
#
# Change ONLY these values if you want to
# fine-tune battlefield positioning.
# =========================================================

var enemy_positions = [

	Vector2(495, 250),
	Vector2(615, 250),
	Vector2(735, 250)

]


var player_positions = [

	Vector2(495, 420),
	Vector2(615, 420),
	Vector2(735, 420)

]


# =========================================================
# CHARACTER ARRAYS
# =========================================================

var player_characters: Array[Node] = []
var enemy_characters: Array[Node] = []


# =========================================================
# SETUP CHARACTERS
# =========================================================

func setup_characters(
	player_heroes: Array,
	enemy_heroes: Array,
	battlefield: Node
):

	print("================================")
	print("CHARACTER MANAGER")
	print("SETTING UP CHARACTERS")
	print("================================")


	# =====================================================
	# CLEAR OLD REFERENCES
	# =====================================================

	player_characters.clear()
	enemy_characters.clear()


	# =====================================================
	# VALIDATE DATA
	# =====================================================

	if player_heroes.size() < 3:

		push_error(
			"CharacterManager: Not enough player heroes"
		)

		return


	if enemy_heroes.size() < 3:

		push_error(
			"CharacterManager: Not enough enemy heroes"
		)

		return


	if battlefield == null:

		push_error(
			"CharacterManager: Battlefield is NULL"
		)

		return


	# =====================================================
	# ENEMY CHARACTERS
	# =====================================================

	print("")
	print("---------- ENEMY ----------")


	for i in range(3):

		var hero: Dictionary = enemy_heroes[i]

		var character = CHARACTER_SCENE.instantiate()


		# -------------------------------------------------
		# ADD TO BATTLEFIELD
		# -------------------------------------------------

		battlefield.add_child(character)


		# -------------------------------------------------
		# POSITION
		# -------------------------------------------------

		character.position = enemy_positions[i]


		# -------------------------------------------------
		# SETUP HERO
		# -------------------------------------------------

		character.setup_hero(
			hero,
			"front"
		)


		# -------------------------------------------------
		# STORE
		# -------------------------------------------------

		enemy_characters.append(character)


		print(
			"EnemyHero",
			i + 1,
			" → ",
			hero["name"],
			" | Position: ",
			enemy_positions[i]
		)


	# =====================================================
	# PLAYER CHARACTERS
	# =====================================================

	print("")
	print("---------- PLAYER ----------")


	for i in range(3):

		var hero: Dictionary = player_heroes[i]

		var character = CHARACTER_SCENE.instantiate()


		# -------------------------------------------------
		# ADD TO BATTLEFIELD
		# -------------------------------------------------

		battlefield.add_child(character)


		# -------------------------------------------------
		# POSITION
		# -------------------------------------------------

		character.position = player_positions[i]


		# -------------------------------------------------
		# SETUP HERO
		# -------------------------------------------------

		character.setup_hero(
			hero,
			"back"
		)


		# -------------------------------------------------
		# STORE
		# -------------------------------------------------

		player_characters.append(character)


		print(
			"PlayerHero",
			i + 1,
			" → ",
			hero["name"],
			" | Position: ",
			player_positions[i]
		)


	# =====================================================
	# RESULT
	# =====================================================

	print("")
	print("================================")

	print(
		"PLAYER CHARACTERS: ",
		player_characters.size()
	)

	print(
		"ENEMY CHARACTERS: ",
		enemy_characters.size()
	)

	print("================================")
