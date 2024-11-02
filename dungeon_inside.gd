extends Node2D

var entered = false
var outside = "res://hub.tscn"


func _on_exit_body_entered(body: Node2D) -> void:
	if entered:
		get_tree().change_scene_to_file("res://scenes/hub.tscn")


func _on_exit_body_exited(body: Node2D) -> void:
	entered = true
