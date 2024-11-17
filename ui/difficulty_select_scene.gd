extends Node2D

@onready var animation_player = $AnimationPlayer as AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_easy_button_pressed() -> void:
	Global.difficulty = 1
	get_tree().change_scene_to_file(Global.room_entry.pick_random())

func _on_medium_button_pressed() -> void:
	Global.difficulty = 2
	get_tree().change_scene_to_file(Global.room_entry.pick_random())

func _on_hard_button_pressed() -> void:
	Global.difficulty = 3
	get_tree().change_scene_to_file(Global.room_entry.pick_random())

func _on_nightmare_button_pressed() -> void:
	Global.difficulty = 4
	get_tree().change_scene_to_file(Global.room_entry.pick_random())
