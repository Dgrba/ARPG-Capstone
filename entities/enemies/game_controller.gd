extends Node2D
class_name game_controller

@onready var player: Player = $player_test
@onready var enemies: Array[Enemy] = []
var wait_time_between_turns = 1 # Set the wait time between each enemy's turn

func _ready():
	player.turn_end.connect(_on_player_end_turn)

func _on_enemy_death(enemy: Enemy):
	if enemies.find(enemy) != -1:
		enemies.remove_at(enemies.find(enemy))

func _on_player_end_turn():
	if enemies.size() == 0:
		player.start_turn()
		return
	for enemy in enemies:
		enemy.on_player_turn_end()
	await get_tree().create_timer(wait_time_between_turns).timeout
	player.start_turn()

func register_enemies():
	if enemies.size() > 0:
		player.in_combat = true
		player.enemies = enemies
		for enemy in enemies:
			enemy.enemy_death.connect(_on_enemy_death)
	else:
		player.in_combat = false
		player.enemies.clear()

func _on_changed_enemies():
	register_enemies()
