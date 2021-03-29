extends Node

var player
var GLOBALS : Reference = preload("res://conf/GLOBALS.gd")
var velocity : Vector2 = Vector2.ZERO


func _ready():
	player = get_tree().get_nodes_in_group("Player")

func HandleInput(_host, _delta):
	pass
