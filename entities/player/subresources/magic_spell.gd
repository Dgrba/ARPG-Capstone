extends Sprite2D

@onready var particle_sprite: AnimatedSprite2D = $ParticleSprite
var heading: String

func set_direction(new_heading: String):
	heading = new_heading
	particle_sprite.flip_h = false
	particle_sprite.flip_v = false
	if heading.contains("left"):
		frame = 2
		particle_sprite.offset = Vector2(8, 0)
		particle_sprite.play("disperse_horizontal")
	elif heading.contains("right"):
		frame = 3
		particle_sprite.offset = Vector2(-8, 0)
		particle_sprite.play("disperse_horizontal")
		particle_sprite.flip_h = true
	elif heading.contains("up"):
		frame = 0
		particle_sprite.offset = Vector2(0, 8)
		particle_sprite.play("disperse_vertical")
		particle_sprite.flip_v = true
	elif heading.contains("down"):
		frame = 1
		particle_sprite.play("disperse_vertical")
		particle_sprite.offset = Vector2(0, -8)
