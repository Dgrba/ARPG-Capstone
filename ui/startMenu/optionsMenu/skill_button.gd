extends TextureButton

# player is used to initialize the stats resource
@onready var player: Player = get_parent().get_parent().get_parent().get_parent()
#variable to access player stat features
@onready var stats: StatComponent = player.statComponent
#variable to access player health features
@onready var health: HealthComponent = player.healthComponent
#variable to access player movement features
@onready var movement: MovementComponent = player.moveComponent
@onready var action: ActionComponent = player.actionComponent

#declare labels
@onready var vigor_label = %VigorLabel
@onready var dash_label = %DashLabel
@onready var berserker_label = %BerserkerLabel
@onready var destructive_label = %DestructiveLabel
@onready var resurrection_label = %ResurrectionLabel
@onready var evasive_label = %EvasiveLabel
@onready var resilient_label = %ResiliantLabel
@onready var thaumaturgy_label = %ThaumaturgyLabel
@onready var skill_button_label = %SkillButtonLabel
@onready var skill_button_text = %SkillButtonText
@onready var skill_button_title = %SkillButtonTitle
@onready var currency_label = %CurrencyLabel
@onready var broke_label = %BrokeLabel
@onready var timer = %BrokeTimer

var offset = Vector2(10,10)
var pad = Vector2(5, 5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.set_health(100, 100) #TODO remove this initialization when testing is over
	print("health: ", health._health, "/", health._maxHealth)


func _process(delta):
	skill_button_label.global_position = get_global_mouse_position() + offset
	broke_label.global_position = get_global_mouse_position() + offset
	currency_label.text = "Credits: " + str(player.tokens)

func resize_panel() -> void:
	skill_button_label.size = skill_button_label.get_minimum_size() + pad

# Function to change player stats based on which skill button is pressed
func _on_button_toggled(toggled_on: bool, button: StringName) -> void: 
	if(toggled_on):
		if(player.tokens > 0):
			match button:
				"Vigor":
						health.modify_max_health(50)
						health.modify_health(50)
						print("New health: ", health._health, "/", health._maxHealth)
						player.tokens -= 1
				"Dash":
						player.max_movement *= 2
						print("New speed: ", player.max_movement)
						player.tokens -= 1
				"Berserker":
						action.max_action += 1
						print("New speed: ", player.max_action)
						player.tokens -= 1
				"Destructive":
						stats.modify_stat(StatComponent.StatList.STRENGTH, 5)
						print("New Strength: ", stats.get_stat(StatComponent.StatList.STRENGTH))
						player.tokens -= 1
				"Resurrection":
						health.revive = 1
						print("Revive Token: ", health.revive)
						player.tokens -= 1
				"Evasive":
						stats.modify_stat(StatComponent.StatList.AGILITY, 5)
						print("New Agility: ", stats.get_stat(StatComponent.StatList.AGILITY))
						player.tokens -= 1
				"Resilient":
						stats.modify_stat(StatComponent.StatList.CONSTITUTION, 5)
						print("New Constitution: ", stats.get_stat(StatComponent.StatList.CONSTITUTION))
						player.tokens -= 1
				"Thaumaturgy":
						stats.modify_stat(StatComponent.StatList.INTELLIGENCE, 5)
						print("New Intelligence: ", stats.get_stat(StatComponent.StatList.INTELLIGENCE))
						player.tokens -= 1
						
		else: #IF TOGGLED ON AND PLAYER TOKENS ARE 0
			match button:
				"Vigor":
						set_pressed_no_signal(false)
						skill_button_label.visible = false
						broke_label.visible = true
						timer.start()
				"Dash":
						set_pressed_no_signal(false)
						skill_button_label.visible = false
						broke_label.visible = true
						timer.start()
				"Berserker":
						set_pressed_no_signal(false)
						skill_button_label.visible = false
						broke_label.visible = true
						timer.start()
				"Destructive":
						set_pressed_no_signal(false)
						skill_button_label.visible = false
						broke_label.visible = true
						timer.start()
				"Resurrection":
						set_pressed_no_signal(false)
						skill_button_label.visible = false
						broke_label.visible = true
						timer.start()
				"Evasive":
						set_pressed_no_signal(false)
						skill_button_label.visible = false
						broke_label.visible = true
						timer.start()
				"Resilient":
						set_pressed_no_signal(false)
						skill_button_label.visible = false
						broke_label.visible = true
						timer.start()
				"Thaumaturgy":
						set_pressed_no_signal(false)
						skill_button_label.visible = false
						broke_label.visible = true
						timer.start()
					
	else: #IF TOGGLED OFF
			match button:
				"Vigor":
						health.modify_health(-50)
						health.modify_max_health(-50)
						print("New health: ", health._health, "/", health._maxHealth)
						player.tokens += 1
				"Dash":
						player.max_movement /= 2
						print("New speed: ", player.max_movement)
						player.tokens += 1
				"Berserker":
						player.max_action -= 1
						print("New speed: ", player.max_action)
						player.tokens += 1
				"Destructive":
						stats.modify_stat(StatComponent.StatList.STRENGTH, -5)
						print("New Strength: ", stats.get_stat(StatComponent.StatList.STRENGTH))
						player.tokens += 1
				"Resurrection":
						health.revive = 0
						print("Revive Token: ", health.revive)
						player.tokens += 1
				"Evasive":
						stats.modify_stat(StatComponent.StatList.AGILITY, -5)
						print("New Agility: ", stats.get_stat(StatComponent.StatList.AGILITY))
						player.tokens += 1
				"Resilient":
						stats.modify_stat(StatComponent.StatList.CONSTITUTION, -5)
						print("New Constitution: ", stats.get_stat(StatComponent.StatList.CONSTITUTION))
						player.tokens += 1
				"Thaumaturgy":
						stats.modify_stat(StatComponent.StatList.INTELLIGENCE, -5)
						print("New Intelligence: ", stats.get_stat(StatComponent.StatList.INTELLIGENCE))
						player.tokens += 1


#Function to display skill button label when hovered over
func _on_mouse_entered(button: StringName) -> void:
	skill_button_title.text = button
	if(broke_label.visible == true):
		return
	match button:
		"Vigor":
			skill_button_text.text = vigor_label.text
			resize_panel()
			skill_button_label.visible = true
		"Dash": 
			skill_button_text.text = dash_label.text
			resize_panel()
			skill_button_label.visible = true
		"Berserker":
			skill_button_text.text = berserker_label.text
			resize_panel()
			skill_button_label.visible = true
		"Destructive":
			skill_button_text.text = destructive_label.text
			resize_panel()
			skill_button_label.visible = true
		"Resurrection":
			skill_button_text.text = resurrection_label.text
			resize_panel()
			skill_button_label.visible = true
		"Evasive":
			skill_button_text.text = evasive_label.text
			resize_panel()
			skill_button_label.visible = true
		"Resilient":
			skill_button_text.text = resilient_label.text
			resize_panel()
			skill_button_label.visible = true
		"Thaumaturgy":
			skill_button_text.text = thaumaturgy_label.text
			resize_panel()
			skill_button_label.visible = true

#Function to hide skill button label when mouse leaves hovering
func _on_mouse_exited(button: StringName) -> void:
	skill_button_label.visible = false

func _on_timer_timeout() -> void:
	broke_label.visible = false
