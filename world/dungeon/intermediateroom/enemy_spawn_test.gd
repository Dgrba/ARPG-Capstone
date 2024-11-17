extends game_controller

#enemy variables
@onready var main: game_controller = get_parent()


var enemy_1 := preload("res://entities/enemies/enemy_1.tscn")
var enemy_3 := preload("res://entities/enemies/enemy_3.tscn")
var enemy_5 := preload("res://entities/enemies/enemy_5.tscn")
var enemy_7 := preload("res://entities/enemies/enemy_7.tscn")

var enemies_rand = ['a','b', 'c', 'd']
#spawner variables
var spawn_points := []
var enemy_count = Global.number
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_parent().name)
	
	if get_parent().name == "square_base_large" or get_parent().name == "square_base" or get_parent().name == "circle_base" :
		enemy_count = enemy_count * 2
		
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)

func track() -> void:
	print("###############################")
	for i in main.enemies:
		print(i)
		

func _on_timer_timeout() -> void:
	track()
	if enemy_count > 0:
		var spawn = spawn_points[randi() % spawn_points.size()]
		var enemy = enemies_rand.pick_random()
		if(enemy == 'a'):
			var spawning_enemy = enemy_1.instantiate()
			spawning_enemy.position = spawn.position
			main.add_child(spawning_enemy);
			main.enemies.append(spawning_enemy)
		elif(enemy == 'b'):
			var spawning_enemy = enemy_3.instantiate()
			spawning_enemy.position = spawn.position
			main.add_child(spawning_enemy);
			main.enemies.append(spawning_enemy)
		elif(enemy == 'c'):
			var spawning_enemy = enemy_5.instantiate()
			spawning_enemy.position = spawn.position
			main.add_child(spawning_enemy);
			main.enemies.append(spawning_enemy)
		elif(enemy == 'd'):
			var spawning_enemy = enemy_7.instantiate()
			spawning_enemy.position = spawn.position
			main.add_child(spawning_enemy);
			main.enemies.append(spawning_enemy)
		enemy_count = enemy_count - 1
	main.hide_door()
