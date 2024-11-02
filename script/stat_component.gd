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
# _stats contains the mapping from StatList to the numeric value of a that stat
var _stats: Dictionary

# initialization function; takes JSON object with structure:
# {
#	"health": 100,
#	"max_health": 100,
#	"stats": {
#		"STRENGTH": 10,
#		"DEXTERITY": 10,
#		"CONSTITUTION": 10,
#		"AGILITY": 10,
#		"INTELLIGENCE": 10,
#		},
#}
func from_json(object: JSON):
	_stats = object.data.stats

# get a stat from _stats
# if parameter target is not int, StatList or String returns "ERROR"
# otherwise returns the interger value of the target stat
func get_stat(target):
	if typeof(target) == TYPE_STRING:
		return _stats[StatList.keys()[StatList.keys().find(target)]]
	elif typeof(target) == TYPE_INT:
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
func set_stat(target: StatList, value: int):
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
	var current_value = _stats[StatList.keys()[target]]
	if value < 1 && current_value != 0:
		stat_hit_zero.emit(target)
	elif value > 0 && current_value == 0:
		stat_no_longer_zero.emit(target)
	if value < 1:
		value = 0
	return value
