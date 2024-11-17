class_name Player
extends CharacterBody2D

signal turn_end
signal action_used(actionType: Action.ActionCategory)
signal stats_changed(new_stats: Dictionary)  # New signal for stats update
signal hit
signal failed_action

var enemy_in_attack_zone = false
var enemy_attack_cooldown = true
var health = 150
#credits used to buy skills
var tokens = 0
var player_alive = true
var attack_action = false  # anim

const SPEED = 100.0
var current_direction = "move_down"

@onready var status_menu: Control = $StatsMenu as Control  # More robust type casting for status menu
@onready var fighting_ui = $FightingScene

var EXP = 10

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_zone = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_zone = false

func enemy_attack():
	if enemy_in_attack_zone == true:
		healthComponent.modify_health(-5)

#func update_healthbar():
	#var healthbar = $healthbar
	#healthbar.value = healthComponent.get_health()
	#if health >= healthComponent.get_max_health():
		#healthbar.visible = false
	#else:
		#healthbar.visible = true

const SaveFile = "res://../SaveData.ini"
const DefaultSaveData = "res://entities/player/DefaultData.ini"

@export var anim: AnimationPlayer
@export var sprite: Sprite2D
@export var healthComponent: HealthComponent
@export var moveComponent: MovementComponent
@export var statComponent: StatComponent
@export var shadowComponent: ShadowComponent
@export var actionComponent: ActionComponent
@export var magicSpell: Sprite2D

var enemies: Array[Enemy] = []
var player_turn: bool = true
const MELEE_DISTANCE = 16
const MAGIC_DISTANCE = 32

var active: bool = true
# TODO trigger toggle when enter/exit combat
var in_combat: bool = false

enum AnimationType {
	Idle, Walk, Attack
}

func start_turn():
	player_turn = true
	actionComponent.reset_allowed_actions()
	# Connect health component signal
	#healthComponent.health_changed.connect(_on_health_changed)

	# Initialize player stats dictionary
	var initial_stats = {
		"health": healthComponent.get_health(),
		"max_health": healthComponent.get_max_health(),
		"allowedActions": actionComponent.allowedActions,
		"stats": {
			"STRENGTH": statComponent.get_stat("STRENGTH"),
			"DEXTERITY": statComponent.get_stat("DEXTERITY"),
			"CONSTITUTION": statComponent.get_stat("CONSTITUTION"),
			"AGILITY": statComponent.get_stat("AGILITY"),
			"INTELLIGENCE": statComponent.get_stat("INTELLIGENCE")
		}
	}
	status_menu.update_stats(initial_stats)

# Function to update the stats menu dynamically
func update_stats_menu() -> void:
	var current_stats = {
		"health": healthComponent.get_health(),
		"max_health": healthComponent.get_max_health(),
		"allowedActions": actionComponent.allowedActions,
		"stats": {
			"STRENGTH": statComponent.get_stat("STRENGTH"),
			"DEXTERITY": statComponent.get_stat("DEXTERITY"),
			"CONSTITUTION": statComponent.get_stat("CONSTITUTION"),
			"AGILITY": statComponent.get_stat("AGILITY"),
			"INTELLIGENCE": statComponent.get_stat("INTELLIGENCE")
		}
	}
	status_menu.update_stats(current_stats)

# Health change function to update stats menu
func _on_health_changed():
	update_stats_menu()

func end_turn():
	turn_end.emit()

# Modify end turn to reset actions and update stats menu
func _on_end_turn():
	player_turn = false
	actionComponent.reset_allowed_actions()
	update_stats_menu()
	enemy_attack()
	shadowComponent.clear()
	play_idle_anim()

func _on_failed_action():
	print("Failed to act - maybe you're too tired?")

# helper function for safely retrieving data from a json file or defaulting to
# a manually passed value
# Parameters:
#	json: the target JSON object
#	target: the desired attribute (skip the outer 'data' but include other nested objects)
#	default: the desired default value to return
func get_or_default(json: JSON, target: String, default):
	var res = json.get("data").get(target)
	if (res == null):
		print("error with ", target, " returning default...")
		return default
	return res

func _ready() -> void:
	load_state()
	setHouse(null)

func _on_move_end(dist: Vector2 = Vector2.ZERO, backward = true):
	play_idle_anim()
	queue_redraw()

func  play_idle_anim(dist: Vector2 = Vector2.ZERO):
	magicSpell.hide()
	proceed_with_anim()
	anim.queue(_get_animation(AnimationType.Idle, current_direction))

func undo():
	actionComponent.undo_action()
	shadowComponent.remove_back()

func _on_move_start(direction: String, backward: bool = false, shadow: bool = true):
	if !backward && shadow:
		shadowComponent.add_pose(Player.AnimationType.Idle, current_direction, global_position, is_magic())
	play_movement_anim(direction, backward)

func _on_failed_movement():
	shadowComponent.failed_move()
	play_idle_anim()

func proceed_with_anim():
	if anim.current_animation.contains("attack"):
		anim.play()
	else:
		anim.stop()

func  play_movement_anim(direction: String, backward):
	magicSpell.hide()
	proceed_with_anim()
	anim.queue(_get_animation(AnimationType.Walk, direction))
	current_direction =  direction

# TODO a more graceful handling for use_action would be nice
func _unhandled_input(event: InputEvent) -> void:
	if !player_turn || moveComponent.is_moving():
		return
	var is_movement = event.is_action_pressed("move_left") || event.is_action_pressed("move_down") || event.is_action_pressed("move_right") || event.is_action_pressed("move_up")
	if !in_combat:
		if is_movement:
			if event.is_action_pressed(current_direction):
				moveComponent.move(event, false, false)
			else: 
				current_direction = MovementComponent.string_from_event(event)
				play_idle_anim()
		elif event.is_action_pressed("attack_enemy"):
			attack(AttackAction.new(), false)
	if is_movement and in_combat:
		if event.is_action_pressed(current_direction) && actionComponent.can_use_action(Action.ActionCategory.Movement):
			var action = actionComponent.use_action(Action.ActionCategory.Movement, event, moveComponent)
			action.set_undo(moveComponent, event)
			moveComponent.move(event)
		else:
			current_direction = MovementComponent.string_from_event(event)
			play_idle_anim()
	elif event.is_action_pressed("undo") and in_combat:
		undo()
	elif in_combat and event.is_action_pressed("attack_enemy") && actionComponent.can_use_action(Action.ActionCategory.Action):
		var action = actionComponent.use_action(Action.ActionCategory.Action, event)
		attack(action as AttackAction)
	elif event is InputEventKey and event.is_action_pressed("interact") and house != null:
		house.enter()
	elif event.is_action_pressed("debug"):
		debug()



func debug():
	if !in_combat:
		in_combat = true
	#if active:
		#healthComponent.set_health(0)
	#else:
		#healthComponent.set_health(healthComponent._maxHealth)
	turn_end.emit()
	# in game_map this happens automatically (when enemy turns end)
	actionComponent.reset_allowed_actions()
	player_turn = true

# logic for dealing with player death; connected to death signal in _ready()
func _on_player_death():
	anim.stop()
	update_stats_menu()
	active = false
	anim.queue("death")
	print("You are dead!")

func _on_resurrection():
	active = true
	# TODO this function calls on ready, which is before this function works
	#update_stats_menu()
	print("You have come back to life!")
	anim.queue(_get_animation(AnimationType.Idle))

func _on_body_entered(body: Node2D) -> void:
	hit.emit()

#Script For Key Press on house
var house :set = setHouse

func setHouse(newHouse):
	if newHouse != null:
		$Key.show()
		$KeyPrompt.play("KeyPrompt")
	else:
		$Key.hide()
		$KeyPrompt.stop()
	house = newHouse

func is_magic() -> bool:
	if statComponent.get_class_name() == StatComponent.Class.Mage:
		return true
	else:
		return false

func attack(action: AttackAction, shadow: bool = true):
	var dist: Vector2
	var hits: Array[Enemy]
	if is_magic():
		dist = attack_magic(MAGIC_DISTANCE, shadow)
	else:
		dist = attack_melee(MELEE_DISTANCE, shadow)
	var damage: int = _attack_damage()
	for enemy in enemies:
		if position.x - enemy.position.x <= dist.x + 16 && position.y - enemy.position.y <= 16 || position.y - enemy.position.y <= dist.y + 16 && position.x - enemy.position.x <= 16:
			enemy.health -= damage
			hits.push_back(enemy)
	action.set_undo(hits, damage)

func _attack_damage() -> int:
	if is_magic():
		return statComponent.get_stat("Intelligence") * 1.2
	else:
		return statComponent.get_stat("Strength") * 1.5

func attack_melee(distance: int = MELEE_DISTANCE, shadow: bool = true) -> Vector2:
	if shadow:
		shadowComponent.add_pose(Player.AnimationType.Attack, current_direction, global_position, is_magic())
	proceed_with_anim()
	anim.queue(_get_animation(AnimationType.Attack))
	Global.player_current_attack = true
	attack_action = true
	var anim_timer = get_tree().create_timer(0.38)
	anim_timer.timeout.connect(func():
		anim.pause()
		Global.player_current_attack = false
		attack_action = false
		)
	var dist: Vector2
	match current_direction:
		"move_left":
			dist = Vector2(-distance, 0)
		"move_down":
			dist = Vector2(0, distance)
		"move_right":
			dist = Vector2(distance, 0)
		"move_up":
			dist = Vector2(0, -distance)
	return dist

func attack_magic(distance: int = MAGIC_DISTANCE, shadow: bool = true) -> Vector2:
	magicSpell.position = Vector2.ZERO
	magicSpell.show()
	magicSpell.set_direction(current_direction)
	var dist: Vector2
	match current_direction:
		"move_left":
			dist = Vector2(-distance, 0)
		"move_down":
			dist = Vector2(0, distance)
		"move_right":
			dist = Vector2(distance, 0)
		"move_up":
			dist = Vector2(0, -distance)
	var tween = create_tween().tween_property(magicSpell, "position", magicSpell.position + dist, 0.5)
	tween.finished.connect((func(shadow: bool):
		if shadow:
			shadowComponent.add_pose(Player.AnimationType.Attack, current_direction, global_position, is_magic())
	).bind(shadow))
	proceed_with_anim()
	anim.queue(_get_animation(AnimationType.Attack))
	Global.player_current_attack = true
	attack_action = true
	var anim_timer = get_tree().create_timer(0.38)
	anim_timer.timeout.connect(func():
		anim.pause()
		Global.player_current_attack = false
		attack_action = false
		)
	return dist

# This is the preferred way to fetch an animation for the anim.play() function
# because it manages whether the sprite is flipped
func _get_animation(animType: AnimationType, direction: String = current_direction, backward: bool = false):
	var animation: String
	current_direction = direction
	match (direction):
		"move_up":
			if backward:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
			animation = "back_"
		"move_left":
			if backward:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
			animation = "side_"
		"move_right":
			if backward:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
			animation = "side_"
		"move_down":
			if backward:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
			animation = "front_"
	match animType:
		AnimationType.Idle:
			animation += "idle"
		AnimationType.Walk:
			animation += "walk"
		AnimationType.Attack:
			animation += "attack"
	return animation

func save_state():
	var config := ConfigFile.new()
	
	var stats := get_node("StatComponent") as StatComponent
	config.set_value("Stats", "Strength", stats.get_stat("STRENGTH"))
	config.set_value("Stats", "Dexterity", stats.get_stat("DEXTERITY"))
	config.set_value("Stats", "Constitution", stats.get_stat("CONSTITUTION"))
	config.set_value("Stats", "Agility", stats.get_stat("AGILITY"))
	config.set_value("Stats", "Intelligence", stats.get_stat("INTELLIGENCE"))
	config.set_value("Stats", "Class", stats.get_class_string())
	
	config.set_value("Moves", "ActionMax", actionComponent.max_action)
	config.set_value("Moves", "BonusMax", actionComponent.max_bonus)
	config.set_value("Moves", "MovementMax", actionComponent.max_movement)
	config.set_value("Moves", "ActionAvailable", actionComponent.allowedActions[Action.ActionCategory.Action])
	config.set_value("Moves", "BonusAvailable", actionComponent.allowedActions[Action.ActionCategory.Bonus])
	config.set_value("Moves", "MovementAvailable", actionComponent.allowedActions[Action.ActionCategory.Movement])
	
	var health := get_node("HealthComponent") as HealthComponent
	config.set_value("Health", "CurrentHealth", health.get_health())
	config.set_value("Health", "MaxHealth", health.get_max_health())
	
	config.save(SaveFile)

func load_state(SavePath: String = SaveFile):
	var config := ConfigFile.new()
	var err = config.load(SavePath)
	
	if err != OK:
		load_defaults()
		save_state()
		return
	
	var stats = get_node("StatComponent") as StatComponent
	stats.set_stat(StatComponent.StatList.STRENGTH, config.get_value("Stats", "Strength", 0))
	stats.set_stat(StatComponent.StatList.DEXTERITY, config.get_value("Stats", "Dexterity", 0))
	stats.set_stat(StatComponent.StatList.CONSTITUTION, config.get_value("Stats", "Constitution", 0))
	stats.set_stat(StatComponent.StatList.AGILITY, config.get_value("Stats", "Agility", 0))
	stats.set_stat(StatComponent.StatList.INTELLIGENCE, config.get_value("Stats", "Intelligence", 0))
	stats.set_class_name(config.get_value("Stats", "Class", "Melee"))
	
	actionComponent.max_action = config.get_value("Moves", "MaxAction", 1)
	actionComponent.max_bonus = config.get_value("Moves", "MaxBonus", 1)
	actionComponent.max_movement = config.get_value("Moves", "MaxMovement", 1)
	print("loading allowed actions")
	actionComponent.allowedActions[Action.ActionCategory.Action] = config.get_value("Moves", "ActionAvailable", 1)
	actionComponent.allowedActions[Action.ActionCategory.Bonus] = config.get_value("Moves", "BonusAvailable", 1)
	actionComponent.allowedActions[Action.ActionCategory.Movement] = config.get_value("Moves", "MovementAvailable", 1)
	print(actionComponent.allowedActions)
	var health = get_node("HealthComponent") as HealthComponent
	health.set_health(
		config.get_value("Health", "CurrentHealth", 0),
		config.get_value("Health", "MaxHealth", 0)
	)

func load_defaults():
	load_state(DefaultSaveData)

func delete_save():
	DirAccess.remove_absolute(SaveFile)

func _notification(what: int):
	match what:
		NOTIFICATION_EXIT_TREE:
			save_state()

func _on_engagement_area_2d_body_entered(body: Enemy) -> void:
	if body.is_in_group("Enemy"):
		#Global.enemy_types = body.type
		#Global.enemy_health = body.health
		Global.in_combat = true
		fighting_ui.visible = true
		
#func _on_engagement_area_2d_body_entered(body: Node2D) -> void:
#	if body.is_in_group("Enemy"):
#		Global.enemy_type = body.type
#		Global.enemy_health = body.health
#		get_tree().change_scene_to_file.call_deferred("res://ui/fighting_scene.tscn")

func _on_player_hitbox_area_entered(area: Area2D) -> void:
	var damage
	if area.has_method("arrow_deal_damage"):
		damage = 20
		take_arrow_damage(damage)

# TODO fix
func take_arrow_damage(damage):
	health = health - damage
	print("Player health = ", health)
	if health <= 0:
		queue_free()
		#$attack_cooldown.start()
