extends CharacterBody2D

var speed = 100
var player_chase = false
var player_test = null

func _physics_process(delta):
	if player_chase:
		position += (player_test.position - position)/speed
		
		$AnimatedSprite2D.play("side_walk")
		if(player_test.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("side_idle")

func _on_detection_area_body_entered(body):
	player_test = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player_test = null
	player_chase = false
