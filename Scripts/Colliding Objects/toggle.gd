# Use this on any object that has collision with the player
# this script allows us to allow the player to either go through walls or to 
# 	not be able to

extends Node


export var canDashThrough : bool = true

func _ready(): 
	if !canDashThrough:
		# this needs to be named that same for every single collision object
		$DashCollider/DashableCollision.disabled = true

func DisableDash():
	canDashThrough = false