extends Node

onready var PlayerParent = get_parent()
var stats : Stats.Stats
onready var label = get_parent().get_node("RichTextLabel")

func _ready():
	stats = Stats.Stats.new()
	stats.SetHealth(100)
	stats.SetDamage(5)


func _process(_delta):
	label.set_text("health:" + str(stats.GetHealth()))
	if stats.IsDead():
		stats.Die(PlayerParent)
