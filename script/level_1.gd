class_name Level1
extends Control

@onready var exit_button = $Exit_button as Button


# Called when the node enters the scene tree for the first time.
func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)

func on_exit_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")
