extends CharacterBody2D

var speed = 100
var player_chase = false
var player_test = null

var e_health = 100
var EXP = 20
var player_in_attack_zone = false
var can_take_damage = true

func _physics_process(delta):
	damage()
	update_health()

	if player_chase:
		position += (player_test.position - position) / speed
		
		$AnimatedSprite2D.play("side_walk")
		if(player_test.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("front_idle")


func _on_detection_area_body_entered(body):
	player_test = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player_test = null
	player_chase = false

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		print("Player in attack zone")
		player_in_attack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		print("Player out attack zone")
		player_in_attack_zone = false

func damage():
	if player_in_attack_zone and Global.player_current_attack == true:
		if can_take_damage == true:
			e_health = e_health - 15
			$damage_cooldown_timer.start()
			can_take_damage = false
			print("enemy health = ", e_health)
		if e_health <= 0:
			#$AnimatedSprite2D.play("death")
			self.queue_free()


func _on_damage_cooldown_timer_timeout():
	can_take_damage = true


func update_health():
	var healthbar = $healthbar
	healthbar.value = e_health

	if e_health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
