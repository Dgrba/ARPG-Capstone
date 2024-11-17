extends Sprite2D
class_name Pose

const sprite_size = Vector2(32, 32)
var pose: Image
var type: int

func set_pose(new_frame: int):
	frame = new_frame
	pose = texture.get_image().get_region(Rect2i(frame_coords, sprite_size))
