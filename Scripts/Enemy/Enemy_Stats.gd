extends Node

var eStats : EnemyStats.EnemyStats = null
var stats = null

func _ready():
	if get_parent().id == 0:
		get_parent().queue_free()
	else:
		eStats = EnemyStats.EnemyStats.new()
		stats = eStats.SetStatsFromDataID(get_parent().id)

func _process(_delta):
	if stats.IsDead():
		get_parent().queue_free()
