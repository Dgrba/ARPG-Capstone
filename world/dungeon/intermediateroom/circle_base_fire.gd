extends game_controller

var ishidden = false
var in_fire = false

func hide_door() -> void:
	if enemies.is_empty() and ishidden == false:
		ishidden = true
		$Door.queue_free()

func _on_fire_body_entered(body: Node2D) -> void:
	in_fire = true
	print("true")


func _on_fire_body_exited(body: Node2D) -> void:
	in_fire = false
	print("false")


func _on_timer_timeout() -> void:
	print("here")
	if in_fire == true:
		$player_test.healthComponent.modify_health(-Global.fire_damage)
		print("player health is")
		print($player_test.healthComponent.get_health())


func _on_exit_body_entered(body: Node2D) -> void:
	print("entered... ready to exit")
	$player_test.healthComponent.modify_health(($player_test.healthComponent.get_max_health() - $player_test.healthComponent.get_health())*Global.healing_factor )
	get_tree().change_scene_to_file(Global.room_order.pop_front())
