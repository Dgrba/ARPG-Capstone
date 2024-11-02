class_name MovementAction
extends Action

var event: InputEvent
var delegate: MovementComponent

func get_base_category():
	return ActionCategory.Movement

func set_undo(delegate: MovementComponent, event: InputEvent):
	self.event = event
	self.delegate = delegate
	undo = Callable(self, "_undo")

func _undo():
	delegate.move(event, true)
