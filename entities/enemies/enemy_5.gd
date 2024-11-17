extends Enemy

func _ready():
	type = 5
	# Play the default idle animation when the game starts
	$AnimatedSprite2D.play("idle")  # Adjust the animation name to your idle animation

func _physics_process(delta):
	damage()
	update_health()	
	if wander_time > 0:
		position += wander_direction * speed * delta
		wander_time -= delta
		play_movement_animation()		
	player_chases()
	#wander_around(delta)
	#if not player_chase:
		#$AnimatedSprite2D.play("idle")


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
		$AnimatedSprite2D.play("idle")
	elif wander_direction.y > 0:  # Moving south
		$AnimatedSprite2D.play("idle")
	elif wander_direction.x > 0:  # Moving east
		$AnimatedSprite2D.play("idle")
		$AnimatedSprite2D.flip_h = false
	elif wander_direction.x < 0:  # Moving west
		$AnimatedSprite2D.play("idle")
		$AnimatedSprite2D.flip_h = true
		
func enemy():
	pass

func wander_around(delta):
	# Handle the wandering behavior
	if wander_time <= 0:
		# Choose a new random direction to wander
		wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		wander_time = wander_interval
		$AnimatedSprite2D.play("idle")
	
	
	else:
		# Move in the chosen direction
		position += wander_direction * (speed * 1) * delta  # Adjust speed multiplier here
		wander_time -= delta

		# Adjust sprite orientation based on direction
		if wander_direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
