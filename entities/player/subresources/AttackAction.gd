class_name AttackAction
extends Action

var damage: int = 0
var enemies: Array[Enemy] = []

func get_base_category():
	return ActionCategory.Action

func set_undo(target_enemies: Array[Enemy], damage_amount: int):
	enemies = target_enemies
	damage = damage_amount
	undo = Callable(self, "_undo")

func _undo():
	for enemy in enemies:
		enemy.health += damage
