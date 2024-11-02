extends Node2D

@export var pause_menu_packed_scene : PackedScene = null
@onready var canvas_layer = $CanvasLayer as CanvasLayer

func _input(event):
	if event.is_action("pause"):
		var new_pause_menu : PauseMenu = pause_menu_packed_scene.instantiate()
		canvas_layer.add_child(new_pause_menu)
