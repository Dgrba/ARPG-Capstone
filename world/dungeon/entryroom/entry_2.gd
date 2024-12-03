extends game_controller


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dungeon.entryroom_enter()

func _on_exit_body_entered(body: Node2D) -> void:
	print("entered... ready to exit")
	get_tree().change_scene_to_file(Global.room_order.pop_front())
