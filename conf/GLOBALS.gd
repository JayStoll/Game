# global variable to be used everywhere in the game
# to use: 
# var GLOBALS = preload("res://conf/GLOBALS.gd")
# then use GLOBALS.WHATEVER_FUNC_OR_VAR_HERE

### groups ###
const DASH_THROUGH_GROUP = "dash"
const OUT_OF_BOUNDS_GROUP = "ofb"
const PLAYER_GROUP = "player"
const ENEMY_GROUP = "enemy"

### physics ###
const GRAVITY : int = 10
# move Speed
const PLAYER_SPEED : int = 150
const SPEED :int = 125

# set the location of the floor
const FLOOR : Vector2 = Vector2(0, -1)

const _KNOCKBACK_AMOUNT : int = 60

# This here becuase everything will take damage
static func TakeDamage(obj, attackDirection : int, amount : int):
	obj.stats.TakeDamage(amount)
	obj.get_parent().position.x += _KNOCKBACK_AMOUNT * attackDirection
