extends Node
class_name Action

enum ActionCategory {
	Action, Bonus, Movement, None,
}

var undo: Callable

func get_base_category() -> ActionCategory:
	return ActionCategory.None

func set_undo(delegate, event):
	undo = Callable(null, "null")

func get_undo():
	return undo
