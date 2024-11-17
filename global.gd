extends Node
var current_house = "" 

var tokens = 0

var last_location = Vector2(0,0);
var enemy_type : int;
var enemy_health : int;
var player_current_attack = false
var enemy_current_attack = false


#Dungeon Stuff
var number = 0
var healing_factor = 0
var difficulty: int = 1 # 1 = easy 2 =medium, 3= hard, 4 = nightmare
var number_rooms = 0
var room_order = []
var room_entry = [
				"res://world/dungeon/entryroom/entry1.tscn",
				"res://world/dungeon/entryroom/entry2.tscn"
				]
				
var room_intermediate = [
						"res://world/dungeon/intermediateroom/Square_base.tscn",
						"res://world/dungeon/intermediateroom/Square_base_fire.tscn",
						"res://world/dungeon/intermediateroom/Square_base_spike.tscn",
						"res://world/dungeon/intermediateroom/Square_large_base.tscn",
						"res://world/dungeon/intermediateroom/Square_large_base_fire.tscn",
						"res://world/dungeon/intermediateroom/Square_large_base_spike.tscn",
						"res://world/dungeon/intermediateroom/Circle_base.tscn",
						"res://world/dungeon/intermediateroom/Circle_base_fire.tscn",
						"res://world/dungeon/intermediateroom/Circle_base_spike.tscn"
						]
var room_end = [
				"res://world/dungeon/exitroom/exit1.tscn",
				"res://world/dungeon/exitroom/exit2.tscn"
				]

var fire_damage = 1
var spike_damage = 1

var player_pos : Vector2;
var in_combat : bool = false;
