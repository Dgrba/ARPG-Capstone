extends Node2D

@export var pause_menu_packed_scene : PackedScene = null
@onready var canvas_layer = $CanvasLayer as CanvasLayer
@export var scene: PackedScene

func _input(event):
	if event.is_action("pause"):
		var new_pause_menu : PauseMenu = pause_menu_packed_scene.instantiate()
		canvas_layer.add_child(new_pause_menu)

func _ready() -> void:
	if(Global.last_location != Vector2(0,0)):
		print("Global != 00")
		$CanvasLayer/player_test.position = Global.last_location
	else:
		print("Global = 00")
		$CanvasLayer/player_test.position = Vector2(288,384)



func _on_item_shop_area_body_entered(body: Node2D) -> void:
	Global.last_location = $CanvasLayer/player_test.position + Vector2(0,16)
	get_tree().change_scene_to_file("res://world/hub/interiors/item_shop_inside.tscn")


func _on_magic_shop_area_body_entered(body: Node2D) -> void:
	Global.last_location = $CanvasLayer/player_test.position + Vector2(0,16)
	get_tree().change_scene_to_file("res://world/hub/interiors/magic_shop_inside.tscn")


func _on_dungeon_building_area_body_entered(body: Node2D) -> void:
	Global.last_location = $CanvasLayer/player_test.position + Vector2(0,16)
	get_tree().change_scene_to_file("res://world/hub/interiors/Dungeon_inside.tscn")
