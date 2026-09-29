extends Control

const SCREENS := {
	"title": "res://assets/figma/title.png", "menu": "res://assets/figma/menu.png",
	"stages": "res://assets/figma/stages.png", "deck": "res://assets/figma/deck.png",
	"battle": "res://assets/figma/battle.png", "quiz": "res://assets/figma/quiz.png",
	"victory": "res://assets/figma/victory.png", "defeat": "res://assets/figma/defeat.png",
	"ticket": "res://assets/figma/ticket.png", "reward": "res://assets/figma/reward.png",
}

var screen := "title"
var background: TextureRect
var overlay: Control
var game_ui: Control
var hint: Label
var player_hp := 12
var enemy_hp := 12
var tickets := 0
var cards := ["Axe Man", "Gigantopithecus", "Mammoth", "Sanjeevani Herb"]
var wins := 0

func _ready() -> void:
	background = TextureRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	overlay = Control.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	game_ui = Control.new()
	game_ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	game_ui.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(game_ui)
	hint = Label.new()
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 9)
	hint.add_theme_color_override("font_color", Color("fff5cf"))
	hint.add_theme_color_override("font_shadow_color", Color("241709"))
	hint.add_theme_constant_override("shadow_offset_x", 1)
	hint.add_theme_constant_override("shadow_offset_y", 1)
	hint.position = Vector2(0, 326)
	hint.size = Vector2(615, 14)
	hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(hint)
	show_screen("title")

func show_screen(next_screen: String) -> void:
	screen = next_screen
	background.texture = load(SCREENS[screen])
	clear_children(overlay)
	clear_children(game_ui)
	match screen:
		"title":
			hint.text = "CLICK TO BEGIN"
			add_hotspot(Rect2(0, 0, 615, 343), func(): show_screen("menu"))
		"menu": build_menu()
		"stages": build_stages()
		"deck": build_deck()
		"battle": build_battle()
		"quiz": build_quiz()
		"victory": build_result(true)
		"defeat": build_result(false)
		"ticket": build_ticket()
		"reward": build_reward()

func build_menu() -> void:
	hint.text = "Choose a path"
	add_hotspot(Rect2(211, 75, 168, 39), func(): start_battle())
	add_hotspot(Rect2(211, 145, 168, 39), func(): show_screen("deck"))
	add_hotspot(Rect2(211, 215, 168, 39), func(): show_screen("stages"))
	add_hotspot(Rect2(211, 285, 168, 39), func(): hint.text = "Settings are coming soon")
	var status := make_label("Wins: %d   Draw tickets: %d" % [wins, tickets], 9)
	status.position = Vector2(14, 14)
	game_ui.add_child(status)

func build_stages() -> void:
	hint.text = "Choose an era"
	add_hotspot(Rect2(47, 49, 263, 143), func(): start_battle())
	add_hotspot(Rect2(337, 192, 263, 143), func(): hint.text = "Indus Valley unlocks after 5 wins")

func build_deck() -> void:
	hint.text = "Your collection. Press Esc to return."
	add_hotspot(Rect2(0, 0, 95, 343), func(): show_screen("menu"))
	var collection := make_label("COLLECTION (%d cards)\n%s" % [cards.size(), "  •  ".join(cards)], 9)
	collection.position = Vector2(100, 294)
	collection.size = Vector2(400, 28)
	collection.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_ui.add_child(collection)

func start_battle() -> void:
	player_hp = 12
	enemy_hp = 12
	show_screen("battle")

func build_battle() -> void:
	hint.text = "Defeat the enemy before your heroes fall"
	var panel := make_panel(Rect2(476, 88, 128, 150))
	var title := make_label("BATTLE\n\nYou: %d HP\nEnemy: %d HP" % [player_hp, enemy_hp], 10)
	title.position = Vector2(8, 8)
	title.size = Vector2(112, 62)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(title)
	panel.add_child(make_button("AXE STRIKE (-3)", Rect2(8, 76, 112, 26), func(): take_turn(3, 0)))
	panel.add_child(make_button("HERB (+2)", Rect2(8, 108, 112, 26), func(): take_turn(0, 2)))
	game_ui.add_child(panel)

func take_turn(damage: int, healing: int) -> void:
	enemy_hp = max(0, enemy_hp - damage)
	player_hp = min(12, player_hp + healing)
	if enemy_hp <= 0:
		show_screen("quiz")
		return
	player_hp = max(0, player_hp - 2)
	if player_hp <= 0:
		show_screen("defeat")
		return
	show_screen("battle")

func build_quiz() -> void:
	hint.text = "Correct answer earns a draw ticket"
	var panel := make_panel(Rect2(112, 66, 390, 215))
	var question := make_label("Which civilization developed along the\nIndus River?", 11)
	question.position = Vector2(20, 16)
	question.size = Vector2(350, 42)
	question.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(question)
	var options := ["A. Mauryan Empire", "B. Indus Valley Civilization", "C. Gupta Empire", "D. Chola Dynasty"]
	for i in options.size():
		panel.add_child(make_button(options[i], Rect2(24, 70 + i * 31, 342, 25), answer_quiz.bind(i == 1)))
	game_ui.add_child(panel)

func answer_quiz(correct: bool) -> void:
	if correct:
		tickets += 1
		wins += 1
		show_screen("victory")
	else:
		hint.text = "Not quite. Try again."

func build_result(won: bool) -> void:
	if won:
		hint.text = "Match won! Your draw ticket is ready."
		add_hotspot(Rect2(0, 0, 615, 343), func(): show_screen("ticket"))
	else:
		hint.text = "Your heroes need a new strategy. Click to try again."
		add_hotspot(Rect2(0, 0, 615, 343), func(): start_battle())

func build_ticket() -> void:
	hint.text = "Use your ticket to draw a new card"
	add_hotspot(Rect2(256, 229, 103, 49), func(): draw_card())

func draw_card() -> void:
	if tickets <= 0:
		hint.text = "Win a match first to earn a ticket"
		return
	tickets -= 1
	if not cards.has("Indus Scout"):
		cards.append("Indus Scout")
	show_screen("reward")

func build_reward() -> void:
	hint.text = "Indus Scout joined your collection. Click to return to the hub."
	add_hotspot(Rect2(0, 0, 615, 343), func(): show_screen("menu"))

func make_panel(area: Rect2) -> Panel:
	var panel := Panel.new()
	panel.position = area.position
	panel.size = area.size
	var style := StyleBoxFlat.new()
	style.bg_color = Color("342418e8")
	style.border_color = Color("e3bd73")
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	panel.add_theme_stylebox_override("panel", style)
	return panel

func make_label(text_value: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("fff3d1"))
	label.add_theme_color_override("font_shadow_color", Color("1d120a"))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	return label

func make_button(text_value: String, area: Rect2, action: Callable) -> Button:
	var button := Button.new()
	button.text = text_value
	button.position = area.position
	button.size = area.size
	button.add_theme_font_size_override("font_size", 8)
	button.pressed.connect(action)
	return button

func add_hotspot(area: Rect2, action: Callable) -> void:
	var button := Button.new()
	button.position = area.position
	button.size = area.size
	button.flat = true
	button.modulate = Color(1, 1, 1, 0)
	button.pressed.connect(action)
	overlay.add_child(button)

func clear_children(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed() and event.keycode == KEY_ESCAPE and screen != "title":
		show_screen("menu")
		get_viewport().set_input_as_handled()
