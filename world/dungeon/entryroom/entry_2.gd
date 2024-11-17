extends Room


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dungeon.entryroom_enter()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("entered... ready to exit")
	Global.tokens = Global.tokens + 1
	get_tree().change_scene_to_file(Global.room_order.pop_front())
	
