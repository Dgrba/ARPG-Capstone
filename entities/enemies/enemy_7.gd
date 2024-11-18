extends Enemy


var bow_equiped = true
var bow_cooldown = true
var arrow = preload("res://entities/enemies/fire_ball.tscn")

func shoot_player():
	# Only shoot if bow is equipped, cooldown is over, and the player is within range
	if bow_equiped and bow_cooldown and player_chase:
		bow_cooldown = false

		# Aim at the player position
		var direction_to_player = (player_test.position - position).normalized()
		$Marker2D.rotation = direction_to_player.angle()

		# Create and shoot the arrow
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position

		add_child(arrow_instance)
		
		await get_tree().create_timer(2.5).timeout
		bow_cooldown = true

func _ready():
	type = 7
	# Play the default idle animation when the game starts
	$AnimatedSprite2D.play("front_idle")  # Adjust the animation name to your idle animation

func _physics_process(delta):
	#if Input.is_action_just_pressed("attack"):
	if wander_time > 0:
		position += wander_direction * speed * delta
		wander_time -= delta
		play_movement_animation()
	#damage()
	#update_health()
	#wander_around(delta)
	#player_chases()
	
# Only wander if the enemy is not chasing the player
	#if not player_chase:
		#$AnimatedSprite2D.play("front_idle")
	if player_chase:
		update_animation_direction()

func on_player_turn_end():
	move_enemy()
	shoot_player()
	
func move_enemy():
	if wander_time <= 0:
		var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
		wander_direction = directions[randi() % directions.size()]
		wander_time = max_wander_time / 2
	
func play_movement_animation():
	# Determine which animation to play based on wander_direction
	if wander_direction.y < 0:  # Moving north
		$AnimatedSprite2D.play("back_walk")
	elif wander_direction.y > 0:  # Moving south
		$AnimatedSprite2D.play("front_walk")
	elif wander_direction.x > 0:  # Moving east
		$AnimatedSprite2D.play("side_walk")
		$AnimatedSprite2D.flip_h = false
	elif wander_direction.x < 0:  # Moving west
		$AnimatedSprite2D.play("side_walk")
		$AnimatedSprite2D.flip_h = true
		
func enemy():
	pass

func wander_around(delta):
	# Handle the wandering behavior
	if wander_time <= 0:
		# Choose a new random direction to wander
		wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		wander_time = wander_interval
		$AnimatedSprite2D.play("side_walk")
	else:
		# Move in the chosen direction
		position += wander_direction * (speed * 1) * delta  # Adjust speed multiplier here
		wander_time -= delta
		# Adjust sprite orientation based on direction
		if wander_direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false

func update_animation_direction():
	# Calculate the direction to the player
	var direction_to_player = (player_test.position - position).normalized()

	# Determine the facing animation based on the direction
	if abs(direction_to_player.x) < 0.5 and direction_to_player.y < 0:  # North
		$AnimatedSprite2D.play("back_walk")
	elif abs(direction_to_player.x) < 0.5 and direction_to_player.y > 0:  # South
		$AnimatedSprite2D.play("front_walk")
	elif direction_to_player.x > 0 and abs(direction_to_player.y) < 0.5:  # East
		$AnimatedSprite2D.play("side_walk")
	elif (player_test.position.x - position.x) < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
