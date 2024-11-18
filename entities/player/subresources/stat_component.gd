extends Node2D
class_name StatComponent

signal stat_hit_zero(StatList)
signal stat_no_longer_zero(StatList)

enum StatList {
	# melee damage
	STRENGTH = 0,
	# projectile damage
	DEXTERITY = 1,
	# health and/or resistance to damage
	CONSTITUTION = 2,
	# evasion chance
	AGILITY = 3,
	# spell damage and/or chance
	INTELLIGENCE = 4,
}
enum Class {
	Melee = 0,
	Mage = 1,
}
# _stats contains the mapping from StatList to the numeric value of a that stat
var _stats: Dictionary
var _class: Class

func _ready():
	pass

func set_class_name(classname):
	_class = Class.Melee
	match classname as String:
		"Mage":
			_class = Class.Mage

func get_class_name() -> Class:
	return _class

func get_class_string() -> String:
	match _class:
		Class.Melee:
			return "Melee"
		Class.Mage:
			return "Mage"
	return "Melee"

func stat_from_string(str: String) -> StatList:
	str = str.strip_edges().to_lower()
	match str.to_lower():
		"strength":
			return StatList.STRENGTH
		"dexterity":
			return StatList.DEXTERITY
		"constitiution":
			return StatList.CONSTITUTION
		"agility":
			return StatList.AGILITY
		"intelligence":
			return StatList.INTELLIGENCE
	return StatList.STRENGTH

# get a stat from _stats
# if parameter target is not int, StatList or String returns "ERROR"
# otherwise returns the interger value of the target stat
func get_stat(target):
	if typeof(target) == TYPE_STRING and _stats.has(stat_from_string(target)):
		return _stats[stat_from_string(target)]
	elif typeof(target) == TYPE_INT and StatList.keys().has(target):
		return _stats[StatList.keys()[target]]
	else:
		return "ERROR"

# get all stats returns a read-only deep copy of the _stats object
# this is pretty slow and wasteful (memory), avoid if possible
# possible alternative:
# ```
# for key in StatList.keys():
# 	var tmp = get_stat(key)
# 	Your Code Here
# ```
func get_stats_all():
	var tmp = _stats.duplicate()
	tmp.make_read_only()
	return tmp

# for manual initialization or hard scripting
func set_stat(target, value: int):
	value = _on_stat_changed(target, value)
	_stats[StatList.keys()[target]] = value

# modifies the target stat by value
# use negative to decrease
func modify_stat(target: StatList, value: int):
	var new_value = _stats[StatList.keys()[target]] + value
	new_value = _on_stat_changed(target, new_value)
	_stats[StatList.keys()[target]] = new_value

# this function allows error checking and signals on stat changes
# it must be manually placed in functions which change stats
# this function is why I made _stats private
# it returns an approved value for target, after sanity checking
func _on_stat_changed(target: StatList, value: int) -> int:
	if !_stats.has(target):
		_stats[target] = value
		return value
	var current_value = _stats[target]
	if value < 1 && current_value != 0:
		stat_hit_zero.emit(target)
	elif value > 0 && current_value == 0:
		stat_no_longer_zero.emit(target)
	if value < 1:
		value = 0
	return value
