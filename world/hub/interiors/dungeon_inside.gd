extends game_controller

var entered = false
var outside = "res://hub.tscn"

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	get_tree().change_scene_to_file("res://ui/difficulty_select_scene.tscn")


func _on_exit_body_exited(body: Node2D) -> void:
	entered = true
	print("True")



func _on_exit_body_entered(body: Node2D) -> void:
	if entered == true:
		get_tree().change_scene_to_file("res://world/hub/hub.tscn")
