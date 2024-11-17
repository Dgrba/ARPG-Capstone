extends Node2D
class_name ShadowComponent

@export var parent: Node2D

@export var canvas: CanvasLayer
var poses: Array[Sprite2D]
var skip: bool = false

enum PoseKey {
	IdleDown = 0,
	IdleSide = 6,
	IdleUp = 12,
	WalkDown = 21,
	WalkSide = 24,
	WalkUp = 33,
	AttackDown = 37,
	AttackSide = 43,
	AttackUp = 49,
}

func get_posekey(type: Player.AnimationType, heading: String) -> PoseKey:
	var key: PoseKey
	match type:
		Player.AnimationType.Attack:
			if heading.contains("left"):
				key = PoseKey.AttackSide
			elif heading.contains("right"):
				key = PoseKey.AttackSide
			elif heading.contains("up"):
				key = PoseKey.AttackUp
			elif heading.contains("down"):
				key = PoseKey.AttackDown
		Player.AnimationType.Walk:
			if heading.contains("left"):
				key = PoseKey.WalkSide
			elif heading.contains("right"):
				key = PoseKey.WalkSide
			elif heading.contains("up"):
				key = PoseKey.WalkUp
			elif heading.contains("down"):
				key = PoseKey.WalkDown
		Player.AnimationType.Idle:
			if heading.contains("left"):
				key = PoseKey.IdleSide
			elif heading.contains("right"):
				key = PoseKey.IdleSide
			elif heading.contains("up"):
				key = PoseKey.IdleUp
			elif heading.contains("down"):
				key = PoseKey.IdleDown
	return key

func add_pose(type: Player.AnimationType, heading: String = parent.current_direction, position: Vector2 = parent.global_position, magic: bool = false):
	if skip:
		skip = false
		return
	if type == Player.AnimationType.Attack:
		skip = true
	var pose
	if !magic:
		pose = preload("res://entities/player/subresources/poses/Pose.tscn").instantiate()
	else:
		pose = preload("res://entities/player/subresources/poses/MagicPose.tscn").instantiate()
	pose.set_pose(get_posekey(type, heading))
	if heading.contains("left"):
		pose.flip_h = true
	pose.position = position - Vector2(0, 16)
	pose.type = type
	canvas.add_child(pose)
	if magic && type == Player.AnimationType.Attack:
		pose.set_magic_pose(heading)
	poses.push_back(pose)

func _ready():
	pass

func failed_move():
	remove_back()

func clear():
	poses.clear()
	skip = false
	for child in canvas.get_children():
		canvas.remove_child(child)
		child.queue_free()

func remove_back():
	if poses.size() < 1:
		return
	var tmp = poses.pop_back()
	if tmp.type == Player.AnimationType.Attack:
		skip = false
	canvas.remove_child(tmp)
	tmp.queue_free()
