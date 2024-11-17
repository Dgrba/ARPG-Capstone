extends Node

#on entry/exit Room
func entryroom_enter() -> void:
	Global.last_location = Vector2(288,576)
	difficulty_set()
	enemies_set()
	fire_damage_set()
	spike_damage_set()
	generate_room_array()
	print_array()

#Room Generation
func difficulty_set() -> void:
	if Global.difficulty == 0:
		Global.number_rooms = 2
	elif Global.difficulty == 1:
		Global.number_rooms = 4
	elif Global.difficulty == 2:
		Global.number_rooms = 6
	elif Global.difficulty == 3:
		Global.number_rooms = 10
	else:
		Global.number_rooms = 3
		
func generate_room_array() -> void:
	for i in Global.number_rooms:
		Global.room_order.push_back(Global.room_intermediate.pick_random())
	Global.room_order.push_back(Global.room_end.pick_random())
	Global.room_order.push_back("res://world/hub/hub.tscn")
	Global.last_location = Vector2(0,0) #UPDATE WHEN MERGED
	
func print_array() -> void:
	for i in Global.room_order:
		print(i)
		
#Room Parameters

func fire_damage_set() -> void:
	if Global.difficulty == 0:
		Global.fire_damage = 10
	elif Global.difficulty == 1:
		Global.fire_damage = 25
	elif Global.difficulty == 2:
		Global.fire_damage = 30
	elif Global.difficulty == 3:
		Global.fire_damage = 35
	else:
		Global.fire_damage = 10
		
func spike_damage_set() -> void:
	if Global.difficulty == 0:
		Global.spike_damage = 5
	elif Global.difficulty == 1:
		Global.spike_damage = 10
	elif Global.difficulty == 2:
		Global.spike_damage = 15
	elif Global.difficulty == 3:
		Global.spike_damage = 20
	else:
		Global.spike_damage = 10

func healing_set() -> void:
	if Global.difficulty == 0:
		Global.healing_factor = 1
	elif Global.difficulty == 1:
		Global.healing_factor = .75
	elif Global.difficulty == 2:
		Global.healing_factor = .50
	elif Global.difficulty == 3:
		Global.healing_factor = 0
	else:
		Global.healing_factor = 1
		
func enemies_set() -> void:
	if Global.difficulty == 0:
		Global.number = 2
	elif Global.difficulty == 1:
		Global.number = 4
	elif Global.difficulty == 2:
		Global.number = 8
	elif Global.difficulty == 3:
		Global.number = 10
	else:
		Global.number = 2
