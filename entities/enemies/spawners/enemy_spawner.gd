extends Node2D

@onready var main = get_node("/root/game_map")

# Load different enemy scenes
var enemy_scenes = [
	#preload("res://entities/enemies/enemy_7.tscn"),
	preload("res://entities/enemies/enemy_3.tscn"),
	#preload("res://entities/enemies/enemy_5.tscn")
]

var spawn_points =[]
var current_enemy = null  # Track the currently spawned enemy



# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)


func _on_timer_timeout():
	# Check if there's an existing enemy and if it has been removed from the scene
	if current_enemy == null or not current_enemy.is_inside_tree():
		# Select a random spawn point
		var spawn = spawn_points[randi() % spawn_points.size()]
		var enemy_scene = enemy_scenes[randi() % enemy_scenes.size()]
		
		# Instantiate and position the enemy
		current_enemy = enemy_scene.instantiate()
		current_enemy.position = spawn.position
		
		# Add the new enemy to the main game scene
		main.add_child(current_enemy)
	
	
