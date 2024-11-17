extends game_controller

func _ready() -> void:
	super._ready()
	enemies = [
		$enemy_3, $enemy_5, $enemy_7,$range_enemy
	]
	#enemies.append($enemy_4)
	register_enemies()
	print(enemies)
