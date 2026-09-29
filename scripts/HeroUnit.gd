extends AnimatedSprite2D


# =========================================================
# STATS
# =========================================================

var max_health: int = 100
var health: int = 100

var dead: bool = false
var is_attacking: bool = false

var hero_data: Dictionary = {}

# back = PLAYER
# front = ENEMY
var battle_side: String = "back"


# =========================================================
# READY
# =========================================================

func _ready():

	if not animation_finished.is_connected(
		_on_animation_finished
	):

		animation_finished.connect(
			_on_animation_finished
	)


# =========================================================
# SETUP HERO
# =========================================================

func setup_hero(
	data: Dictionary,
	side: String = "back"
):

	if data.is_empty():

		push_error(
			"HeroUnit received empty hero data"
		)

		return


	hero_data = data.duplicate(true)

	battle_side = side


	print("================================")
	print("HERO UNIT SETUP")
	print(
		"Hero: ",
		hero_data.get("name", "UNKNOWN")
	)

	print(
		"Side: ",
		battle_side
	)

	print("================================")


	# -----------------------------------------------------
	# HEALTH
	# -----------------------------------------------------

	max_health = int(
		hero_data.get("hp", 100)
	)


	if hero_data.has("current_hp"):

		health = int(
			hero_data["current_hp"]
		)

	else:

		health = max_health


	health = clamp(
		health,
		0,
		max_health
	)


	dead = health <= 0

	is_attacking = false


	# -----------------------------------------------------
	# LOAD ANIMATIONS
	# -----------------------------------------------------

	load_hero_animations(
		hero_data
	)


	# -----------------------------------------------------
	# START IDLE
	# -----------------------------------------------------

	if dead:

		if sprite_frames.has_animation("hurt"):

			play("hurt")

	else:

		if sprite_frames.has_animation("idle"):

			play("idle")


	print(
		"HeroUnit HP: ",
		health,
		"/",
		max_health
	)


# =========================================================
# LOAD HERO ANIMATIONS
# =========================================================

func load_hero_animations(
	data: Dictionary
):

	var hero_name: String = data["name"]


	var folder_name := (
		hero_name
		.to_lower()
		.replace(" ", "_")
	)


	# -----------------------------------------------------
	# NEANDERTHAL
	# -----------------------------------------------------

	if folder_name == "neanderthal_hunter":

		folder_name = "neanderthal"


	# -----------------------------------------------------
	# FOLDER
	# -----------------------------------------------------

	var folder_path := (
		"res://assets/animations/"
		+ folder_name
		+ "/"
		+ battle_side
		+ "/"
	)


	print("--------------------------------")
	print("Loading animations")
	print(
		"Hero: ",
		hero_name
	)

	print(
		"Side: ",
		battle_side
	)

	print(
		"Folder: ",
		folder_path
	)

	print("--------------------------------")


	var new_frames := SpriteFrames.new()


	# -----------------------------------------------------
	# REMOVE DEFAULT
	# -----------------------------------------------------

	for animation_name in \
		new_frames.get_animation_names():

		new_frames.remove_animation(
			animation_name
		)


	# -----------------------------------------------------
	# IDLE
	# -----------------------------------------------------

	load_animation_from_png(
		new_frames,
		"idle",
		folder_path + "idle.png"
	)


	# -----------------------------------------------------
	# ATTACK
	# -----------------------------------------------------

	load_animation_from_png(
		new_frames,
		"attack",
		folder_path + "thrust.png"
	)


	# -----------------------------------------------------
	# HURT
	# -----------------------------------------------------

	load_animation_from_png(
		new_frames,
		"hurt",
		folder_path + "hurt.png"
	)


	# -----------------------------------------------------
	# ASSIGN
	# -----------------------------------------------------

	sprite_frames = new_frames


	# -----------------------------------------------------
	# SETTINGS
	# -----------------------------------------------------

	if sprite_frames.has_animation("idle"):

		sprite_frames.set_animation_speed(
			"idle",
			5.0
		)

		sprite_frames.set_animation_loop(
			"idle",
			true
		)


	if sprite_frames.has_animation("attack"):

		sprite_frames.set_animation_speed(
			"attack",
			8.0
		)

		sprite_frames.set_animation_loop(
			"attack",
			false
		)


	if sprite_frames.has_animation("hurt"):

		sprite_frames.set_animation_speed(
			"hurt",
			8.0
		)

		sprite_frames.set_animation_loop(
			"hurt",
			false
		)


# =========================================================
# LOAD PNG SPRITESHEET
# =========================================================

func load_animation_from_png(
	frames: SpriteFrames,
	animation_name: String,
	path: String
):

	if not ResourceLoader.exists(path):

		print(
			"❌ Animation NOT FOUND: ",
			path
		)

		return


	var texture: Texture2D = load(path)


	if texture == null:

		print(
			"❌ Could not load texture: ",
			path
		)

		return


	var image_size := texture.get_size()


	var frame_height := int(
		image_size.y
	)

	var frame_width := frame_height


	var frame_count := int(
		image_size.x / frame_width
	)


	if frame_count <= 0:

		frame_count = 1


	frames.add_animation(
		animation_name
	)


	for i in range(frame_count):

		var atlas := AtlasTexture.new()

		atlas.atlas = texture

		atlas.region = Rect2(
			i * frame_width,
			0,
			frame_width,
			frame_height
		)


		frames.add_frame(
			animation_name,
			atlas
		)


	print(
		"✅ Loaded: ",
		animation_name,
		" | Frames: ",
		frame_count
	)


# =========================================================
# ATTACK
# =========================================================

func attack():

	if dead:
		return


	if is_attacking:
		return


	if not sprite_frames:
		return


	if not sprite_frames.has_animation(
		"attack"
	):

		print(
			"❌ No attack animation for ",
			hero_data.get(
				"name",
				name
			)
		)

		return


	is_attacking = true


	print(
		"⚔ ",
		hero_data.get(
			"name",
			name
		),
		" ATTACK"
	)


	play("attack")


# =========================================================
# IDLE
# =========================================================

func idle():

	if dead:
		return


	if is_attacking:
		return


	if not sprite_frames:
		return


	if sprite_frames.has_animation("idle"):

		play("idle")


# =========================================================
# HURT
# =========================================================

func hurt():

	if dead:
		return


	if not sprite_frames:
		return


	if sprite_frames.has_animation("hurt"):

		play("hurt")


# =========================================================
# TAKE DAMAGE
# =========================================================

func take_damage(
	amount: int
):

	if dead:
		return


	amount = max(
		amount,
		0
	)


	health -= amount


	health = max(
		health,
		0
	)


	print(
		"💥 ",
		hero_data.get(
			"name",
			name
		),
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
		hero_data.get(
			"name",
			name
		),
		" DIED"
	)


	if sprite_frames.has_animation(
		"hurt"
	):

		play("hurt")


# =========================================================
# IS DEAD
# =========================================================

func is_dead() -> bool:

	return dead


# =========================================================
# ANIMATION FINISHED
# =========================================================

func _on_animation_finished():

	print(
		"Animation finished: ",
		hero_data.get(
			"name",
			name
		),
		" → ",
		animation
	)


	if animation == "attack":

		is_attacking = false


		if not dead:

			idle()


	elif animation == "hurt":

		if not dead:

			idle()
