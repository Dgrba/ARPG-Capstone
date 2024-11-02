extends Node2D
class_name HealthComponent

signal death
signal resurrection

var _health: int: set = _on_set_health
var _maxHealth: int: set = _on_set_maxHealth

func set_health(current: int, max: int = _maxHealth):
	_maxHealth = max
	_health = current

func set_max_health(max: int):
	_maxHealth = max

func modify_health(change: int):
	_health += change

func get_health():
	return _health

func get_max_health():
	return _maxHealth

func _on_set_maxHealth(value: int):
	if value <= 0:
		value = 0
	if _health > value:
		_health = value
	_maxHealth = value

func _on_set_health(value: int):
	if value <= 0:
		value = 0
		death.emit()
	if value > 0 && _health == 0:
		resurrection.emit()
	_health = value
