extends game_controller

var ishidden = false

func hide_door() -> void:
	if enemies.is_empty() and ishidden == false:
		ishidden = true
		$Door.queue_free()

func _on_exit_body_entered(body: Node2D) -> void:
	print("entered... ready to exitw")
	$player_test.healthComponent.modify_health(($player_test.healthComponent.get_max_health() - $player_test.healthComponent.get_health())*Global.healing_factor )
	get_tree().change_scene_to_file(Global.room_order.pop_front())
