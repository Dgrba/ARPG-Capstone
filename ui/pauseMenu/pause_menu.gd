class_name PauseMenu
extends Control

@onready var save = $MarginContainer/VBoxContainer/Save as Button

func _ready():
	get_tree().paused = true
	#save.pressed.connect(_on_save_pressed)

func _on_resume_button_down():
	get_tree().paused = false
	queue_free()

#func _on_save_pressed():
	#get_tree().paused = false
	#SaveManager.save_game()
	#queue_free()

func _on_exit_button_down():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
