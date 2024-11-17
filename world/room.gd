extends Node2D
class_name Room

@onready var player: Player = $player_test
@onready var enemies: Array[Enemy] = []

func _ready():
	player.turn_end.connect(_on_player_end_turn)

func _on_player_end_turn():
	for enemy in enemies:
		enemy.on_player_turn_end()
	player.start_turn()

func register_enemies():
	player.enemies = enemies

func _on_changed_enemies():
	register_enemies()
