extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICTIONARY : Dictionary = {
	"1152 x 648": Vector2i(1152, 648),
	"1280 x 720": Vector2i(1280, 720),
	"1280 x 960": Vector2i(1280, 960),
	"1280 x 1024": Vector2i(1280, 1024),
	"1366 x 768": Vector2i(1366, 768),
	"1600 x 900": Vector2i(1600, 900),
	"1680 x 1050": Vector2i(1680, 1050),
	"1920 x 1080": Vector2i(1920, 1080),
	"2560 x 1440": Vector2i(2560, 1440),
	"3840 x 2160": Vector2i(3840, 2160)
}

# Called when the node enters the scene tree for the first time.
func _ready():
	option_button.item_selected.connect(on_resolution_selected)
	add_resolution_items()
	load_data()
	#centre_window()

func load_data():
	on_resolution_selected(SettingsDataContainer.get_resolution_index())
	option_button.select(SettingsDataContainer.get_resolution_index())

func add_resolution_items():
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)

func on_resolution_selected(index : int):
	SettingsSignalBus.emit_on_resolution_selected(index)
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	
#func centre_window():
	#var centre_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	#var window_size = get_window().get_size_with_decorations()
	#get_window().set_position(centre_screen - window_size/2)
