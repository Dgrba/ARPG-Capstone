class_name Hotkeyrebindbutton
extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

@export var action_name : String = "move_left"
var awaiting_input = false  # Boolean to control input processing

func _ready():
	set_process_input(false)
	#set_process_unhandled_input(false)  # Disable unhandled input by default
	set_action_name()
	set_text_for_key()

# Set label based on the action name
func set_action_name():
	label.text = "Unassigned"
	
	match action_name:
		"move_left":
			label.text = "Move Left"
		"move_right":
			label.text = "Move Right"
		"move_up":
			label.text = "Move Up"
		"move_down":
			label.text = "Move Down"
		"attack_enemy":
			label.text = "Attack"
		"attack_blocked":
			label.text = "Block"

# Function to display the correct key or mouse binding in the button
func set_text_for_key():
	var action_events = InputMap.action_get_events(action_name)
	if action_events.size() > 0:
		var action_event = action_events[0]
		if action_event is InputEventKey:
			button.text = OS.get_keycode_string(action_event.physical_keycode)
		elif action_event is InputEventMouseButton:
			var mouse_button = "Mouse Button " + str(action_event.button_index)
			button.text = mouse_button
		else:
			button.text = "Unassigned"

# When button is pressed, prepare for rebinding
func _on_button_toggled(button_pressed):
	if button_pressed:
		button.text = "Press any key or mouse button..."
		awaiting_input = true  # Enable input processing
		set_process_input(true)  # Allow input processing
		# Disable other buttons while rebinding
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_input(false)
	else:
		awaiting_input = false  # Disable input processing
		set_process_input(false)  # Disable unhandled input processing
		# Re-enable other buttons after rebinding
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_input(false)
		set_text_for_key()  # Ensure the button displays the updated binding

# Handling inputs directly to capture mouse button and key events
func _input(event: InputEvent):
	if awaiting_input:
		if event is InputEventMouseButton and event.pressed:
			rebind_mouse_button(event.button_index)
		elif event is InputEventKey and event.pressed:
			rebind_action_key(event)
			stop_rebinding()

# Function to handle mouse button rebinding
func rebind_mouse_button(button_index: int):
	var event = InputEventMouseButton.new()
	event.button_index = button_index
	event.pressed = true  # Only register press event
	rebind_action_key(event)
	stop_rebinding()

# Stop the rebinding process
func stop_rebinding():
	button.button_pressed = false  # Untoggle the button after rebind
	awaiting_input = false  # Stop awaiting input after rebind
	set_process_input(false)  # Disable unhandled input processing

# Rebind the action to the detected key or mouse button
func rebind_action_key(event: InputEvent):
	var is_duplicate = false
	var action_keycode = ""

	# Determine if it's a keyboard or mouse event
	if event is InputEventKey:
		action_keycode = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		action_keycode = "Mouse Button " + str(event.button_index)
	
	# Check for duplicate keybinds
	for i in get_tree().get_nodes_in_group("hotkey_button"):
		if i.action_name != self.action_name:
			if i.button.text == "%s" % action_keycode:
				is_duplicate = true
				break

	if not is_duplicate:
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
		set_text_for_key()
		set_action_name()
