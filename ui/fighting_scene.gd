extends Node2D

@onready var skillPanel = $SkillPanel
@export var player: Player
@onready var enemy = $Enemy
@onready var healthBar = $Player/PlayerHealth
@onready var enemyHealthBar = $Enemy/EnemyHealth

func _ready() -> void:
	pass
# ===
#	#In the future will dinamicaly set the enemy texture based on the enemy that initiated the fight
#	if Global.enemy_type == 1:
#		enemy.texture = load("res://art/characters/skeleton.png")
#		enemy.hframes = 6
#		enemy.vframes = 13
#	elif Global.enemy_type == 5:
#		enemy.texture = load("res://art/png/survivalgame-enemy-slime.png")
#		enemy.hframes = 14
#		enemy.vframes = 1
# elif Global.enemy_type == 3:
#		enemy.texture = load("res://art/characters/slime.png")
#		enemy.hframes = 7
#		enemy.vframes = 13
# >>> Develop

func _process(delta: float) -> void:
	pass

func _on_skills_button_pressed() -> void:
	if skillPanel.visible:
		skillPanel.visible = false
	else:
		skillPanel.visible  = true


func _on_escape_button_pressed() -> void:
	player.end_turn()
	#Global.in_combat = false
	#visible = false


#---- TO BE IMPLEMENTED: Give player exp, display winning screen and send the player
#                        to old position and scene, the one before the encounter
func win():
	Global.in_combat = false
	visible = false
	pass

#---- TO BE IMPLEMENTED: On lose return player to hub after death animation and fade to black
func lose():
	Global.in_combat = false
	visible = false
