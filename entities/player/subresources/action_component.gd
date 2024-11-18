extends Node2D
class_name ActionComponent

signal failed_action
signal action_used(actionType: Action.ActionCategory)

var max_action: int = 1
var max_bonus: int = 1
var max_movement: int = 1
var allowedActions: Dictionary = {
	Action.ActionCategory.Action: max_action,
	Action.ActionCategory.Bonus: max_bonus,
	Action.ActionCategory.Movement: max_movement,
}
var usedActions: Array[Action.ActionCategory]
var reverseActions: Array[Action]

func _on_change_allowedActions():
	var is_empty: bool = true
	for action in allowedActions.keys():
		if allowedActions[action] > 0:
			is_empty  = false
			break
	if is_empty:
		print("You're out of juice!")

func reset_allowed_actions():
	allowedActions[Action.ActionCategory.Action] = max_action
	allowedActions[Action.ActionCategory.Bonus] = max_bonus
	allowedActions[Action.ActionCategory.Movement] = max_movement
	usedActions.clear()

func undo_action():
	if usedActions.size() < 1:
		return
	reverseActions.pop_back().get_undo().call()
	allowedActions[usedActions.pop_back()] += 1

func _on_failed_action(type: Action.ActionCategory):
	if usedActions.size() < 1 || reverseActions.size() < 1:
		return
	reverseActions.pop_back()

func _is_action_allowed(actionType: Action.ActionCategory) -> Action.ActionCategory:
	var result: Action.ActionCategory = Action.ActionCategory.None
	match actionType:
		Action.ActionCategory.Action:
			if allowedActions[actionType] > 0:
				result = actionType
		Action.ActionCategory.Bonus:
			if allowedActions[actionType] > 0:
				result = actionType
			else:
				result =  _is_action_allowed(Action.ActionCategory.Action)
		Action.ActionCategory.Movement:
			if allowedActions[actionType] > 0:
				result = actionType
			else:
				result = _is_action_allowed(Action.ActionCategory.Bonus)
	return result

func _on_used_action(type: Action.ActionCategory):
	usedActions.push_back(type)

func can_use_action(type: Action.ActionCategory) -> bool:
	if _is_action_allowed(type) != Action.ActionCategory.None:
		return true
	return false

func use_action(actionType: Action.ActionCategory, event: InputEvent, delegate: Node = null) -> Action:
	var initialType = actionType
	actionType = _is_action_allowed(actionType)
	var action: Action
	if actionType != Action.ActionCategory.None:
		match initialType:
			Action.ActionCategory.Action:
				action = AttackAction.new()
				reverseActions.push_back(action)
			Action.ActionCategory.Movement:
				action = MovementAction.new()
				#action.set_undo(delegate, event)
				reverseActions.push_back(action)
			Action.ActionCategory.Bonus:
				pass
		allowedActions[actionType] -= 1
		_on_change_allowedActions()
		action_used.emit(actionType)
		_on_used_action(actionType)
		return action
	failed_action.emit()
	_on_failed_action(actionType)
	action = Action.new()
	return action
