extends Enemy

func _ready():
	type = 3
	# Play the default idle animation when the game starts
	$AnimatedSprite2D.play("side_idle")  # Adjust the animation name to your idle animation

func _physics_process(delta):
	damage()
	update_health()
  
	if wander_time > 0:
		position += wander_direction * speed * delta
		wander_time -= delta
		play_movement_animation()

	#player_chases()
	#wander_around(delta)
#	if not player_chase:
	#	$AnimatedSprite2D.play("front_idle")
	
	if player_chase:
		update_animation_direction()
		
	#if event.is_action_pressed("debug"):
	#	wander_around(delta)
	
func on_player_turn_end():
	print(self, " takes a turn")
	move_enemy()
	
	print(self, " has finished its turn.")

func move_enemy():
	if wander_time <= 0:
		var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
		wander_direction = directions[randi() % directions.size()]
		wander_time = max_wander_time / 2
		print("Random direction chosen:", wander_direction)
	
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
		# Choose a new random horizontal direction to wander (left or right)
		wander_direction = Vector2(randf_range(-1, 1), 0).normalized()  # y component is 0 for left/right movement only
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
