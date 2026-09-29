extends Control


# =========================================================
# MANAGERS
# =========================================================

@onready var battle_manager = $BattleManager
@onready var character_manager = $CharacterManager


# =========================================================
# HERO CARDS
# =========================================================

@onready var hero_card_1 = \
	$HeroCards/HeroCardContainer/HeroCard

@onready var hero_card_2 = \
	$HeroCards/HeroCardContainer/HeroCard2

@onready var hero_card_3 = \
	$HeroCards/HeroCardContainer/HeroCard3


# =========================================================
# PLAYER UI
# =========================================================

@onready var player_health_bar = \
	$PlayerPanel/PlayerHeroStatus1/Content/HealthBar

@onready var player_hp_text = \
	$PlayerPanel/PlayerHeroStatus1/Content/Status


# =========================================================
# ENEMY UI
# =========================================================

@onready var enemy_health_bar = \
	$EnemyPanel/EnemyHeroStatus1/Content/HealthBar

@onready var enemy_hp_text = \
	$EnemyPanel/EnemyHeroStatus1/Content/HPText


# =========================================================
# READY
# =========================================================

func _ready():

	print("================================")
	print("BATTLE SCENE READY")
	print("================================")


	await get_tree().process_frame


	# =====================================================
	# CONNECT CARDS
	# =====================================================

	connect_hero_cards()


	# =====================================================
	# SETUP CARD DATA
	# =====================================================

	setup_player_hero_cards()


	# =====================================================
	# UI
	# =====================================================

	update_ui()


	print("================================")
	print("BATTLE SCENE INITIALIZED")
	print("================================")


# =========================================================
# CONNECT HERO CARDS
# =========================================================

func connect_hero_cards():

	print("================================")
	print("CONNECTING HERO CARDS")
	print("================================")


	if not hero_card_1.hero_selected.is_connected(
		_on_hero_card_1_selected
	):

		hero_card_1.hero_selected.connect(
			_on_hero_card_1_selected
		)

		print("HeroCard 1 connected")


	if not hero_card_2.hero_selected.is_connected(
		_on_hero_card_2_selected
	):

		hero_card_2.hero_selected.connect(
			_on_hero_card_2_selected
		)

		print("HeroCard 2 connected")


	if not hero_card_3.hero_selected.is_connected(
		_on_hero_card_3_selected
	):

		hero_card_3.hero_selected.connect(
			_on_hero_card_3_selected
		)

		print("HeroCard 3 connected")


	print("================================")


# =========================================================
# SETUP PLAYER CARDS
# =========================================================

func setup_player_hero_cards():

	var heroes: Array = \
		battle_manager.player_heroes


	if heroes.size() < 3:

		print(
			"ERROR: Less than 3 player heroes"
		)

		return


	hero_card_1.setup_hero(
		heroes[0]
	)

	hero_card_2.setup_hero(
		heroes[1]
	)

	hero_card_3.setup_hero(
		heroes[2]
	)


	print("================================")
	print("PLAYER HERO CARDS DISPLAYED")
	print("================================")


# =========================================================
# CARD 1
# =========================================================

func _on_hero_card_1_selected(
	data: Dictionary
):

	print("================================")
	print("CARD 1 SIGNAL RECEIVED")
	print("================================")

	handle_hero_selection(
		data,
		0
	)


# =========================================================
# CARD 2
# =========================================================

func _on_hero_card_2_selected(
	data: Dictionary
):

	print("================================")
	print("CARD 2 SIGNAL RECEIVED")
	print("================================")

	handle_hero_selection(
		data,
		1
	)


# =========================================================
# CARD 3
# =========================================================

func _on_hero_card_3_selected(
	data: Dictionary
):

	print("================================")
	print("CARD 3 SIGNAL RECEIVED")
	print("================================")

	handle_hero_selection(
		data,
		2
	)


# =========================================================
# HERO SELECTION
# =========================================================

func handle_hero_selection(
	data: Dictionary,
	slot: int
):

	if data.is_empty():

		return


	print("================================")
	print("HERO CARD SELECTED")

	print(
		"Hero: ",
		data.get(
			"name",
			"UNKNOWN"
		)
	)

	print(
		"Animation ID: ",
		data.get(
			"animation_id",
			"NONE"
		)
	)

	print(
		"CARD SLOT: ",
		slot + 1
	)

	print("================================")


	attack_with_character(
		slot,
		data
	)


# =========================================================
# ATTACK WITH CHARACTER
# =========================================================

func attack_with_character(
	slot: int,
	data: Dictionary
):


	if character_manager == null:

		print(
			"ERROR: CharacterManager missing"
		)

		return


	# =====================================================
	# CHECK PLAYER CHARACTERS
	# =====================================================

	if character_manager.player_characters.size() <= slot:

		print(
			"ERROR: Player character slot does not exist: ",
			slot + 1
		)

		return


	# =====================================================
	# GET CHARACTER
	# =====================================================

	var character = \
		character_manager.player_characters[slot]


	if character == null:

		print(
			"ERROR: Character is NULL"
		)

		return


	# =====================================================
	# DEAD CHECK
	# =====================================================

	if character.is_dead():

		print(
			"Cannot attack. Character is dead."
		)

		return


	# =====================================================
	# ATTACK
	# =====================================================

	print("================================")
	print("⚔ ATTACK")

	print(
		"Hero: ",
		data.get(
			"name",
			"UNKNOWN"
		)
	)

	print(
		"Character Slot: ",
		slot + 1
	)

	print(
		"Character ID: ",
		data.get(
			"animation_id",
			"UNKNOWN"
		)
	)

	print("================================")


	character.attack()


# =========================================================
# UPDATE UI
# =========================================================

func update_ui():

	# =====================================================
	# PLAYER
	# =====================================================

	if battle_manager.player_heroes.size() > 0:

		var player_hero: Dictionary = \
			battle_manager.player_heroes[0]


		var player_hp: int = int(
			player_hero["hp"]
		)


		player_health_bar.max_value = \
			player_hp

		player_health_bar.value = \
			player_hp


		player_hp_text.text = (
			str(player_hp)
			+ " / "
			+ str(player_hp)
		)


	# =====================================================
	# ENEMY
	# =====================================================

	if battle_manager.enemy_heroes.size() > 0:

		var enemy_hero: Dictionary = \
			battle_manager.enemy_heroes[0]


		var enemy_hp: int = int(
			enemy_hero["hp"]
		)


		enemy_health_bar.max_value = \
			enemy_hp

		enemy_health_bar.value = \
			enemy_hp


		enemy_hp_text.text = (
			str(enemy_hp)
			+ " / "
			+ str(enemy_hp)
		)
