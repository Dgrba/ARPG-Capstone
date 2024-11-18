extends Area2D

var speed = 80



func _ready() -> void:
	set_as_top_level(true)

func _process(delta):
	# Move the arrow forward based on its rotation
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

func arrow_deal_damage():
	pass

func _on_visible_on_screen_enabler_2d_screen_exited():
	# Free the arrow when it leaves the screen
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	# Check if the body has a method or property to identify it as the player
	if body.has_method("player") or body.name == "Player":
		# Optional: Apply damage to the player if needed
		body.healthComponent.modify_health(-5)
		queue_free()  # Remove the arrow from the scene
	else:
		print("Arrow miss hit")
