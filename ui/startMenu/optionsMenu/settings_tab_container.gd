extends Control

@onready var hotkey_rebind_button = self  # Refers to itself
@onready var action_list = $"../../VBoxContainer"  # Navigate to the VBoxContainer

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"move_left": "Move Left",
	"move_right": "Move Right",
	"move_up": "Move Up",
	"move_down": "Move Down",
	"attack_enemy": "Attack",
	"attack_blocked": "Block",
}

func _ready():
	_create_action_list()
	set_process_unhandled_input(true)

# Create the action list dynamically
func _create_action_list():
	InputMap.load_from_project_settings()

	if action_list:
		for item in action_list.get_children():
			item.queue_free()

		for action in input_actions:
			if action_list.get_child_count() >= 10:  # Limit number of buttons for testing
				break
			var button = hotkey_rebind_button.duplicate()  # Duplicate the current node (self)
			var action_label = button.get_node("HBoxContainer/Label")  # Correct path
			var input_button = button.get_node("HBoxContainer/Button")  # Correct path
			action_label.text = input_actions[action]

			var events = InputMap.action_get_events(action)
			if events.size() > 0:
				input_button.text = events[0].as_text().trim_suffix(" (Physical)")
			else:
				input_button.text = ""

			# Defer the addition of the button until the parent is ready
			action_list.call_deferred("add_child", button)
			input_button.pressed.connect(_on_input_button_pressed.bind(button, action))
	else:
		print("action_list is null!")






func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.get_node("Button").text = "Press key to bind..."

func _unhandled_input(event):
	if is_remapping:
		if event is InputEventKey or (event is InputEventMouseButton and event.pressed):
			if event is InputEventMouseButton and event.doubleclick:
				event.doubleclick = false

			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)

			is_remapping = false
			action_to_remap = null
			remapping_button = null
			accept_event()

func _update_action_list(button, event):
	button.get_node("Button").text = event.as_text().trim_suffix(" (Physical)")
