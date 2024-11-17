extends Pose

@onready var magicSpell := $MagicSpell

func set_pose(new_frame: int):
	frame = new_frame
	pose = texture.get_image().get_region(Rect2i(frame_coords, sprite_size))

func set_magic_pose(heading: String):
	var magic_position: Vector2
	match heading:
		"move_left":
			magic_position = Vector2(-32, 16)
		"move_down":
			magic_position = Vector2(0, 48)
		"move_right":
			magic_position = Vector2(32, 16)
		"move_up":
			magic_position = Vector2(0, -16)
	magicSpell.position = magic_position
	magicSpell.set_direction(heading)
	magicSpell.show()
