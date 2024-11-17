extends Room

var ishidden = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_door() -> void:
	if enemies.is_empty() and ishidden == false:
		ishidden = true
		$Door.queue_free()


func _on_exit_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("entered... ready to exit")
	$player_test.healthComponent.modify_health(($player_test.healthComponent.get_max_health() - $player_test.healthComponent.get_health())*Global.healing_factor )
	get_tree().change_scene_to_file(Global.room_order.pop_front())
