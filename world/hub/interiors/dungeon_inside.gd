extends game_controller

func _on_exit_area_body_entered(body: Node2D) -> void:
	print("Exiting Dungeon Interior")
	get_tree().change_scene_to_file("res://world/hub/hub.tscn")


func _on_dungeon_enterence_area_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://ui/difficulty_select_scene.tscn")
