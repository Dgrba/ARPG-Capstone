class_name  StartMenu
extends Control

@onready var start_button = $VBoxContainer/Start_Button as Button
@onready var load_button = $VBoxContainer/Load_Button as Button
@onready var options_button = $VBoxContainer/Options_Button as Button
@onready var exit_button = $VBoxContainer/Exit_Button as Button
@onready var options_menu = $Options_Menu as OptionsMenu
@onready var v_box_container = $VBoxContainer as VBoxContainer
@onready var label = $Label as Label
@onready var music_stream_player = $MusicStreamPlayer as AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	handle_connecting_signals()
	if not music_stream_player.playing:
		music_stream_player.play()


func _on_startbutton_pressed():
	get_tree().change_scene_to_file("res://world/hub/hub.tscn")


func _on_loadbutton_pressed():
	print("Load Pressed")


func _on_optionsbutton_pressed():
	v_box_container.visible = false
	label.visible = false
	options_menu.set_process(true)
	options_menu.visible = true


func _on_exitbutton_pressed():
	get_tree().quit()

func _on_exit_options_menu():
	v_box_container.visible = true
	label.visible = true
	options_menu.visible = false

func handle_connecting_signals():
	start_button.button_down.connect(_on_startbutton_pressed)
	options_button.button_down.connect(_on_optionsbutton_pressed)
	exit_button.button_down.connect(_on_exitbutton_pressed)
	options_menu.exit_options_menu.connect(_on_exit_options_menu)
