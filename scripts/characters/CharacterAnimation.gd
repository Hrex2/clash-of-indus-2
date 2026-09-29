extends Node2D


# =========================================================
# HERO DATA
# =========================================================

var hero_data: Dictionary = {}

var battle_side: String = "back"

var max_health: int = 100
var health: int = 100

var dead: bool = false
var is_attacking: bool = false


# =========================================================
# SPRITES
# =========================================================

@onready var front_sprite: AnimatedSprite2D = $Front/AnimatedSprite2D
@onready var back_sprite: AnimatedSprite2D = $Back/AnimatedSprite2D


# =========================================================
# READY
# =========================================================

func _ready():

	front_sprite.visible = false
	back_sprite.visible = false

	if not front_sprite.animation_finished.is_connected(
		_on_animation_finished
	):
		front_sprite.animation_finished.connect(
			_on_animation_finished
	)

	if not back_sprite.animation_finished.is_connected(
		_on_animation_finished
	):
		back_sprite.animation_finished.connect(
			_on_animation_finished
	)


# =========================================================
# SETUP HERO
# =========================================================

func setup_hero(data: Dictionary, side: String = "back"):

	hero_data = data.duplicate(true)

	battle_side = side

	print("================================")
	print("CHARACTER SETUP")
	print("Hero: ", hero_data.get("name", "UNKNOWN"))
	print("Side: ", battle_side)
	print("================================")


	# -------------------------------------------------------
	# HEALTH
	# -------------------------------------------------------

	max_health = int(
		hero_data.get("hp", 100)
	)

	health = max_health

	if hero_data.has("current_hp"):
		health = int(
			hero_data["current_hp"]
		)

	health = clamp(
		health,
		0,
		max_health
	)

	dead = health <= 0
	is_attacking = false


	# -------------------------------------------------------
	# SHOW CORRECT SIDE
	# -------------------------------------------------------

	if battle_side == "front":

		front_sprite.visible = true
		back_sprite.visible = false

		if front_sprite.sprite_frames.has_animation("idle"):
			front_sprite.play("idle")

	else:

		front_sprite.visible = false
		back_sprite.visible = true

		if back_sprite.sprite_frames.has_animation("idle"):
			back_sprite.play("idle")


	print(
		"Hero HP: ",
		health,
		"/",
		max_health
	)


# =========================================================
# GET ACTIVE SPRITE
# =========================================================

func get_active_sprite() -> AnimatedSprite2D:

	if battle_side == "front":
		return front_sprite

	return back_sprite


# =========================================================
# ATTACK
# =========================================================

func attack():

	if dead:
		return

	if is_attacking:
		return

	var sprite := get_active_sprite()

	if sprite == null:
		return

	if not sprite.sprite_frames.has_animation("attack"):
		print(
			"❌ Attack animation missing: ",
			hero_data.get("name", "UNKNOWN")
		)
		return

	is_attacking = true

	print(
		"⚔ ATTACK: ",
		hero_data.get("name", "UNKNOWN")
	)

	sprite.play("attack")


# =========================================================
# IDLE
# =========================================================

func idle():

	if dead:
		return

	if is_attacking:
		return

	var sprite := get_active_sprite()

	if sprite == null:
		return

	if sprite.sprite_frames.has_animation("idle"):
		sprite.play("idle")


# =========================================================
# HURT
# =========================================================

func hurt():

	if dead:
		return

	var sprite := get_active_sprite()

	if sprite == null:
		return

	if sprite.sprite_frames.has_animation("hurt"):
		sprite.play("hurt")


# =========================================================
# TAKE DAMAGE
# =========================================================

func take_damage(amount: int):

	if dead:
		return

	amount = max(amount, 0)

	health -= amount

	health = max(health, 0)

	print(
		"💥 ",
		hero_data.get("name", "UNKNOWN"),
		" HP: ",
		health,
		"/",
		max_health
	)

	if health <= 0:
		die()
	else:
		hurt()


# =========================================================
# DEATH
# =========================================================

func die():

	if dead:
		return

	dead = true
	is_attacking = false
	health = 0

	print(
		"☠ ",
		hero_data.get("name", "UNKNOWN"),
		" DIED"
	)

	var sprite := get_active_sprite()

	if sprite != null:

		if sprite.sprite_frames.has_animation("hurt"):
			sprite.play("hurt")


# =========================================================
# IS DEAD
# =========================================================

func is_dead() -> bool:

	return dead


# =========================================================
# ANIMATION FINISHED
# =========================================================

func _on_animation_finished():

	var sprite := get_active_sprite()

	if sprite == null:
		return

	print(
		"Animation finished: ",
		hero_data.get("name", "UNKNOWN"),
		" → ",
		sprite.animation
	)


	# -------------------------------------------------------
	# ATTACK FINISHED
	# -------------------------------------------------------

	if sprite.animation == "attack":

		is_attacking = false

		if not dead:
			idle()


	# -------------------------------------------------------
	# HURT FINISHED
	# -------------------------------------------------------

	elif sprite.animation == "hurt":

		if not dead:
			idle()
