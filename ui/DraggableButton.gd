extends CharacterBody2D

var draggingDistance : float
var dir : Vector2
var dragging : bool
var newPosition = Vector2()
var mouseIn : bool = false

#If mouse is clicked while hovering button set new target posion and dragging to true
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and mouseIn:
			draggingDistance = position.distance_to(get_viewport().get_mouse_position())
			dir = (get_viewport().get_mouse_position() - position).normalized()
			dragging = true
			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir
		else:
			dragging = false
			
	elif event is InputEventMouseMotion:
		if dragging:
			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir


# Move the button towards new position
func _process(delta: float) -> void:
	if dragging:
		velocity = (newPosition - position) * Vector2(30, 30)
		move_and_slide()


#Handle mouse Etering and leaving grabbable area
func _on_area_2d_mouse_entered() -> void:
	mouseIn = true

func _on_area_2d_mouse_exited() -> void:
	mouseIn = false
