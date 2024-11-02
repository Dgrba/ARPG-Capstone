extends CharacterBody2D

signal turn_end
signal action_used(actionType: Action.ActionCategory)

var enemy_in_attack_zone = false
var enemy_attack_cooldown = true
var health = 150
var player_alive = true

var attack_action = false #anim


const SPEED = 100.0
var current_dir = "none"

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
	if enemy_in_attack_zone and enemy_attack_cooldown == true:
		healthComponent.modify_health(-5)
		enemy_attack_cooldown = false
		var enemy_timer = get_tree().create_timer(1.0)
		enemy_timer.one_shot = true
		enemy_timer.timeout.connect(func ():
			enemy_attack_cooldown = true
		)

#func update_healthbar():
	#var healthbar = $healthbar
	#healthbar.value = healthComponent.get_health()
	#if health >= healthComponent.get_max_health():
		#healthbar.visible = false
	#else:
		#healthbar.visible = true

signal hit
signal failed_action

# player_data is used to initialize the stats resource
var player_data: JSON = preload("res://json/player_data.json")

@export var anim: AnimationPlayer
@export var sprite: Sprite2D
@export var healthComponent: HealthComponent
@export var moveComponent: MovementComponent
@export var statComponent: StatComponent
var reverseActions: Array[Action]
var max_action: int = 1
var max_bonus: int = 1
var max_movement: int = 1
var allowedActions: Dictionary = {
	Action.ActionCategory.Action: max_action,
	Action.ActionCategory.Bonus: max_bonus,
	Action.ActionCategory.Movement: max_movement,
}
var usedActions: Array[Action.ActionCategory]
var current_direction: String
var screen_size
var active: bool = true
var tex: Texture
var relativeLocation: Array[Rect2]
var texLocation: Array[Vector2]

enum AnimationType {
	Idle, Walk, Attack
}

func use_action(actionType: Action.ActionCategory) -> bool:
	actionType = _is_action_allowed(actionType)
	if actionType != Action.ActionCategory.None:
		allowedActions[actionType] -= 1
		_on_change_allowedActions()
		action_used.emit(actionType)
		# TODO place this in function activated by above signal
		usedActions.push_back(actionType)
		return true
	failed_action.emit()
	return false

func _on_failed_action():
	print("Failed to act - maybe you're too tired?")

func undo_action(action: Action):
	if action.get_base_category() == Action.ActionCategory.Movement:
		relativeLocation.pop_back()
		texLocation.pop_back()
	action.get_undo().call()
	allowedActions[usedActions.pop_back()] += 1

func _on_change_allowedActions():
	var is_empty: bool = true
	for action in allowedActions.keys():
		if allowedActions[action] > 0:
			is_empty  = false
			break
	if is_empty:
		print("You're out of juice!")

func _reset_allowed_actions():
	allowedActions[Action.ActionCategory.Action] = max_action
	allowedActions[Action.ActionCategory.Bonus] = max_bonus
	allowedActions[Action.ActionCategory.Movement] = max_movement
	usedActions.clear()

func _is_action_allowed(actionType: Action.ActionCategory) -> Action.ActionCategory:
	var result: Action.ActionCategory = Action.ActionCategory.None
	match actionType:
		Action.ActionCategory.Action:
			if allowedActions[actionType] > 0:
				result = actionType
		Action.ActionCategory.Bonus:
			if allowedActions[actionType] > 0:
				result = actionType
			else:
				result =  _is_action_allowed(Action.ActionCategory.Action)
		Action.ActionCategory.Movement:
			if allowedActions[actionType] > 0:
				result = actionType
			else:
				result = _is_action_allowed(Action.ActionCategory.Bonus)
	return result

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
	tex = sprite.texture
	screen_size = get_viewport_rect().size
	healthComponent.set_health(
		get_or_default(player_data, "max_health", 100),
		get_or_default(player_data, "health", 100)
	)
	statComponent.from_json(player_data)
	setHouse(null)

func  play_idle_anim(dist: Vector2 = Vector2.ZERO, noShadow = true):
	anim.play(_get_animation(AnimationType.Idle, current_direction))
	if !noShadow && dist != Vector2.ZERO:
		_add_shadow(dist)
	_move_shadows(dist)
	queue_redraw()

func _on_end_turn():
	_reset_allowed_actions()
	print("allowed actions reset")
	print("DEBUG: calling enemy attacks...")
	enemy_attack()
	relativeLocation.clear()
	texLocation.clear()
	queue_redraw()

func _add_shadow(dist: Vector2):
	var frame_coords: Vector2
	match current_direction:
		"move_up":
			frame_coords = Vector2(16, 112)
		"move_down":
			frame_coords = Vector2(16, 16)
		"move_left":
			frame_coords = Vector2(16, 64)
		"move_right":
			frame_coords = Vector2(16, 64)
	texLocation.push_back(frame_coords)
	queue_redraw()

func _move_shadows(dist: Vector2):
	for i in range(0, relativeLocation.size()):
		relativeLocation[i] = Rect2(relativeLocation[i].position - dist, relativeLocation[i].size)
	relativeLocation.push_back(Rect2(-(dist - Vector2(-8, -8)), Vector2(32, 32)))

func  play_movement_anim(direction: String, backward = false):
	anim.play(_get_animation(AnimationType.Walk, direction))
	if !backward:
		current_direction = direction

func draw_this():
	for i in range(0, texLocation.size()):
		draw_texture_rect_region(tex, relativeLocation[i], Rect2(texLocation[i], Vector2(32, 32)))

func _draw():
	draw_this()

# TODO a more graceful handling for use_action would be nice
func _unhandled_input(event: InputEvent) -> void:
	if moveComponent.is_moving():
		return
	var is_movement = event.is_action_pressed("move_left") || event.is_action_pressed("move_down") || event.is_action_pressed("move_right") || event.is_action_pressed("move_up")
	if is_movement && use_action(Action.ActionCategory.Movement):
		var action = MovementAction.new()
		action.set_undo(moveComponent, event)
		reverseActions.push_back(action)
		moveComponent.move(event)
	elif event.is_action_pressed("undo"):
		undo_action(reverseActions.pop_back())
	elif event.is_action_pressed("attack_enemy") && use_action(Action.ActionCategory.Action):
		var action = AttackAction.new()
		action.set_undo(null, event)
		reverseActions.push_back(action)
		attack()
	elif event is InputEventKey and event.is_action_pressed("interact") and house != null:
		#global.player_pos = global_position
		house.enter()
	elif event.is_action_pressed("debug"):
		turn_end.emit()


# logic for dealing with player death; connected to death signal in _ready()
func _on_player_death():
	active = false
	anim.play("death")
	print("You are dead!")

func _on_resurrection():
	active = true
	print("You have come back to life!")
	anim.play(_get_animation(AnimationType.Idle))

func _on_body_entered(body: Node2D) -> void:
	hit.emit()

#Script For Key Press on house
var house :set = setHouse

func setHouse(newHouse):
	if newHouse != null:
		$Key.show()
		anim.play("KeyPrompt")
	else:
		$Key.hide()
		anim.stop()
	house = newHouse

func attack():
	anim.play(_get_animation(AnimationType.Attack))
	Global.player_current_attack = true
	attack_action = true
	var attack_timer = get_tree().create_timer(1.0)
	attack_timer.timeout.connect(func():
		Global.player_current_attack = false
		attack_action = false
		anim.play(_get_animation(AnimationType.Idle))
	)

func _on_attack_action_timer_timeout():
	Global.player_current_attack = false
	attack_action = false

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
