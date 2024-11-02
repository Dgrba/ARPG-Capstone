extends Node2D
class_name MovementComponent

# move_start includes an argument giving the direction of the movement
signal move_start(String, bool)
# parent node is expected to remember what the last movement direction was if necessary
signal move_end(Vector2)

@export var parent: Node2D
const tile_size = 16
var anim_speed = 2
var moving = false


static var move_directions = {
	"move_up": Vector2.UP,
	"move_left": Vector2.LEFT,
	"move_down": Vector2.DOWN,
	"move_right": Vector2.RIGHT
}

var pos: Vector2: set = _on_set_pos

@export var ray: RayCast2D

static func reverse_event(event: InputEvent) -> String:
	for dir in move_directions.keys():
		if event.is_action_pressed(dir):
			match dir:
				"move_up":
					return "move_down"
				"move_down":
					return "move_up"
				"move_right":
					return "move_left"
				"move_left":
					return "move_right"
	return ""

func _on_set_pos(value):
	position = value
	pos = position
	parent.position = value

# generic movement function; can be called directly for npc movement
func move_direction(direction: String, backward: bool = false):
	move_start.emit(direction, backward)
	var dist = move_directions[direction] * tile_size
	if backward:
		dist = -dist
	ray.target_position = dist
	ray.force_raycast_update()
	if !ray.is_colliding():
		var tween = create_tween()
		tween.tween_property(self, "pos",
			pos + dist, 1.0/anim_speed).set_trans(Tween.TRANS_LINEAR)
		moving = true
		await tween.finished
		moving = false
	else:
		dist = 0
	move_end.emit(dist, backward)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pos = get_parent().position

func is_moving():
	return moving

# handles player-controlled movement; returns string for current direction key
func move(event: InputEvent, backward = false):
	if moving:
		return
	for dir in move_directions.keys():
		if event.is_action_pressed(dir):
			#move_start.emit(dir)
			await move_direction(dir, backward)
			#move_end.emit(dir)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
