extends game_controller

func _on_exit_body_entered(body: Node2D) -> void:
	print("entered... ready to exit")
	Global.tokens = Global.tokens + 1
d	get_tree().change_scene_to_file(Global.room_order.pop_front())
