extends Enemy

func _ready():
	type = 8
	# Play the default idle animation when the game starts
	$AnimatedSprite2D.play("idle")  # Adjust the animation name to your idle animation
# Bow
var bow_equiped = true
var bow_cooldown = true
var arrow = preload("res://entities/enemies/arrow.tscn")

func _physics_process(delta):
	if wander_time > 0:
		position += wander_direction * speed * delta
		wander_time -= delta
		play_movement_animation()
	#else:
		#wander_around(delta)  # Trigger direction change and reset time if needed
	#damage()
	#update_health()
	
	
	# Only wander if the enemy is not chasing the player
	#if not player_chase:
		#wander_around(delta)
		#$AnimatedSprite2D.play("idle")

	if player_chase:
		update_animation_direction()

#control the enemy's turn
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
		$AnimatedSprite2D.play("n_walk")
	elif wander_direction.y > 0:  # Moving south
		$AnimatedSprite2D.play("s_walk")
	elif wander_direction.x > 0:  # Moving east
		$AnimatedSprite2D.play("e_walk")
	elif wander_direction.x < 0:  # Moving west
		$AnimatedSprite2D.play("w_walk")
		
func enemy():
	pass
	
func wander_around(delta):
	# If it's time to switch direction, change the movement direction
	if wander_time <= 0:
		# Toggle between North to South (down) and South to North (up)
		if wander_direction.y == 1:  # Currently moving South
			wander_direction = Vector2(0, -1)  # Change direction to North
			$AnimatedSprite2D.play("n_walk")  
		else:  # Currently moving North
			wander_direction = Vector2(0, 1)  # Change direction to South
			$AnimatedSprite2D.play("s_walk")  

		# Reset the wander time to max_wander_time and play the appropriate animation
		wander_time = max_wander_time
	else:
		# Continue walking in the current direction for the set time
		wander_time -= delta
		position += wander_direction * speed * delta

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


func update_animation_direction():
	# Calculate the direction to the player
	var direction_to_player = (player_test.position - position).normalized()

	# Determine the facing animation based on the direction
	if abs(direction_to_player.x) < 0.5 and direction_to_player.y < 0:  # North
		$AnimatedSprite2D.play("n_attack")
	elif abs(direction_to_player.x) < 0.5 and direction_to_player.y > 0:  # South
		$AnimatedSprite2D.play("s_attack")
	elif direction_to_player.x > 0 and abs(direction_to_player.y) < 0.5:  # East
		$AnimatedSprite2D.play("e_attack")
	elif direction_to_player.x < 0 and abs(direction_to_player.y) < 0.5:  # West
		$AnimatedSprite2D.play("w_attack")
	elif direction_to_player.x > 0 and direction_to_player.y < 0:  # Northeast
		$AnimatedSprite2D.play("ne_attack")
	elif direction_to_player.x > 0 and direction_to_player.y > 0:  # Southeast
		$AnimatedSprite2D.play("se_attack")
	elif direction_to_player.x < 0 and direction_to_player.y > 0:  # Southwest
		$AnimatedSprite2D.play("sw_attack")
	elif direction_to_player.x < 0 and direction_to_player.y < 0:  # Northwest
		$AnimatedSprite2D.play("nw_attack")
