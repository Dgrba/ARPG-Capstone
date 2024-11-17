extends Node2D

func _ready() -> void:
	pass # Replace with function body.

@export var scene: PackedScene

func _on_area_2d_body_entered(body) -> void:
	body.house = self

func _on_area_2d_body_exited(body) -> void:
	if body.house == self:
		body.house = null

func enter():
	get_tree().change_scene_to_file("res://world/hub/interiors/item_shop_inside.tscn")
