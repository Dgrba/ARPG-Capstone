class_name Action
extends Node

enum ActionCategory {
	Action, Bonus, Movement, None,
}

var undo: Callable

func get_base_category() -> ActionCategory:
	return ActionCategory.None

func set_undo(delegate, info):
	undo = Callable(null, "null")

func get_undo():
	return undo
