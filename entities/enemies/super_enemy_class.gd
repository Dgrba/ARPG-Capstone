class_name Enemy
extends CharacterBody2D

signal enemy_death(enemy: Enemy)

# Wandering AI variables
var wander_direction = Vector2.ZERO
var wander_time = 0.0
var wander_interval = 2  # Adjust as needed
var max_wander_time = 7  # Time in seconds before switching direction



# Shared properties
var type = 1
var speed = 10
var health = 100: set = _on_update_health
var EXP = 20
var player_chase = false
var player_test = null
var dead = false

func _on_update_health(new_health: int):
	if new_health < 0:
		handle_death()
	health = new_health
	update_health()

#update the health
var healthbar_path = "healthbar"

#damage
var can_take_damage = true
var player_in_attack_zone = false  # Set to true/false in subclasses when player enters/exits the attack zone

# Initialize the enemy type
#var type = 1  # Default type can be overwritten in subclasses

func on_player_turn_end():
	pass



func player_chases():
	if player_chase and player_test != null:
		var direction = (player_test.position - position).normalized()
		velocity = direction * speed
		move_and_collide(velocity * get_process_delta_time())

		if player_in_attack_zone:
			$AnimatedSprite2D.play("side_attack")
			$AnimatedSprite2D.flip_h = (player_test.position.x < position.x)


func _on_detection_area_body_entered(body):
	player_test = body
	player_chase = true
	print("Player detected by enemy")

func _on_detection_area_body_exited(body):
	player_test = null
	player_chase = false

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		print("Player in attack zone")
		player_in_attack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		print("Player out attack zone")
		player_in_attack_zone = false

	
#func damage():
	#if player_in_attack_zone and Global.player_current_attack == true:
		#if can_take_damage:
			#health -= 15  # Decrease health by 15 or adjust as needed
			#$damage_cooldown_timer.start()  # Start cooldown to prevent immediate repeated damage
			#can_take_damage = false
			#print("enemy health = ", health)
		#if health <= 0 and !dead:
			#print("Enemy is dead")
			#handle_death()  # Call the death handling function

func take_damage(amount):
	health -= amount
	if health <= 0 and !dead:
		handle_death()

func handle_death():
	dead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	enemy_death.emit(self)
	queue_free()
	
func _on_damage_cooldown_timer_timeout():
	can_take_damage = true

func update_health():
	print("update health: ", self)
	print(health)
	var healthbar = $healthbar
	healthbar.value = health

	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
