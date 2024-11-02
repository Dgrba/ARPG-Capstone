extends Node

const SETTINGS_SAVE_PATH : String = "user://SettingsData.save"
const SAVE_PATH : String = "user://GameData.save"

signal game_saved
signal game_loaded

var settings_data_dict : Dictionary = {}

func _ready():
	SettingsSignalBus.set_settings_dictionary.connect(on_settings_save)
	load_settings_data()

var current_save : Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0,
	},
	items = [],
	persistence = [],
}

func save_game():
	var game_data = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.WRITE, "ARPG")
	var save_game_json = JSON.stringify(current_save)
	game_data.store_line(save_game_json)
	game_saved.emit()
	print("save game")
	pass


func load_game():
	print("load game")
	pass



func on_settings_save(data : Dictionary):
	var save_settings_data_file = FileAccess.open_encrypted_with_pass(SETTINGS_SAVE_PATH, FileAccess.WRITE, "ARPG")
	
	var json_data_string = JSON.stringify(data)
	
	save_settings_data_file.store_line(json_data_string)
func load_settings_data():
	if not FileAccess.file_exists(SETTINGS_SAVE_PATH):
		return
	
	var save_settings_data_file = FileAccess.open_encrypted_with_pass(SETTINGS_SAVE_PATH, FileAccess.READ, "ARPG")
	var _loaded_data : Dictionary = {}
	
	while save_settings_data_file.get_position() < save_settings_data_file.get_length():
		var json_string = save_settings_data_file.get_line()
		var json = JSON.new()
		var _parsed_result = json.parse(json_string)
		
		_loaded_data = json.get_data()
	
	SettingsSignalBus.emit_load_settings_data(_loaded_data)
