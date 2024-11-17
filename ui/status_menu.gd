extends Control

var player_stats: Dictionary = {
	"health": 100,
	"max_health": 100,
	"allowedActions": {
		0: 1,  # Action
		1: 1,  # Bonus
		2: 1   # Movement
	},
	"stats": {
		"STRENGTH": 10,
		"DEXTERITY": 10,
		"CONSTITUTION": 10,
		"AGILITY": 10,
		"INTELLIGENCE": 10,
	}
}

var tween: Tween
var background_panel: Panel

func _ready():
	# Set up the background panel for click-outside detection
	background_panel = Panel.new()
	background_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	background_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	background_panel.modulate = Color(0, 0, 0, 0.5)
	add_child(background_panel)
	background_panel.hide()
	background_panel.gui_input.connect(_on_background_clicked)
	
	# Initialize and display the stats UI
	create_stats_ui()
	modulate = Color(1, 1, 1, 0)
	hide()

# Sets up the stat display UI elements
func create_stats_ui():
	# Create the main container
	var panel = PanelContainer.new()
	add_child(panel)
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	margin.add_child(vbox)
	
	# Add title
	var title = Label.new()
	title.text = "Player Stats"
	title.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title)
	
	# Add separator
	vbox.add_child(HSeparator.new())
	
	# Add health
	add_stat_row(vbox, "Health", str(player_stats.health) + " / " + str(player_stats.max_health))
	
	# Add actions section
	var action_title = Label.new()
	action_title.text = "Available Actions"
	action_title.add_theme_font_size_override("font_size", 18)
	vbox.add_child(action_title)
	
	# Convert action enum to readable names
	var action_names = {
		0: "Actions",
		1: "Bonus Actions",
		2: "Movement"
	}
	
	# Add available actions
	for action_type in player_stats.allowedActions:
		var available = player_stats.allowedActions[action_type]
		var name = action_names[action_type]
		add_stat_row(vbox, name, str(available))
	
	# Add separator before base stats
	vbox.add_child(HSeparator.new())
	
	# Add base stats
	var stats_title = Label.new()
	stats_title.text = "Attributes"
	stats_title.add_theme_font_size_override("font_size", 18)
	vbox.add_child(stats_title)
	
	for stat_name in player_stats.stats:
		add_stat_row(vbox, stat_name, str(player_stats.stats[stat_name]))

# Updates the UI with new stats when called
func update_stats(new_stats: Dictionary) -> void:
	player_stats = new_stats
	# Clear existing UI (except background panel) and recreate it with new stats
	for child in get_children():
		if child != background_panel:
			child.queue_free()
	create_stats_ui()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_stats_menu"):
		toggle_menu()
		get_viewport().set_input_as_handled()

func _on_background_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			toggle_menu()

func toggle_menu() -> void:
	if visible:
		fade_out()
	else:
		fade_in()

func fade_in() -> void:
	show()
	background_panel.show()
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)
	tween.tween_property(background_panel, "modulate", Color(0, 0, 0, 0.5), 0.2)

func fade_out() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.2)
	tween.tween_property(background_panel, "modulate", Color(0, 0, 0, 0), 0.2)
	tween.tween_callback(func():
		hide()
		background_panel.hide()
	)

func add_stat_row(container: Container, label_text: String, value_text: String) -> void:
	var hbox = HBoxContainer.new()
	container.add_child(hbox)
	
	var label = Label.new()
	label.text = label_text + ":"
	label.custom_minimum_size.x = 120
	hbox.add_child(label)
	
	var value = Label.new()
	value.text = value_text
	hbox.add_child(value)
