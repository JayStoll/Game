extends Node

var eStats : EnemyStats.EnemyStats = null
var stats = null

onready var sprite : Sprite = get_node("../Flip/Sprite")

func _ready():
	if get_parent().id == 0:
		get_parent().queue_free()
	else:
		eStats = EnemyStats.EnemyStats.new()
		stats = eStats.SetStatsFromDataID(get_parent().id)
		eStats.SetSprite(sprite)

func _process(_delta):
	if stats.IsDead():
		stats.Die(get_parent())
