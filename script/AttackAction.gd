class_name AttackAction
extends Action

var event: InputEvent

func get_base_category():
	return ActionCategory.Action

# TODO figure out how to undo an attack (something with enemy)
func set_undo(delegate, event: InputEvent):
	self.event = event
	undo = Callable(self, "_undo")

func _undo():
	print("TODO: undo for attack")
