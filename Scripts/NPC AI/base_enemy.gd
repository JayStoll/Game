extends KinematicBody2D

# global variables
var GLOBALS : Reference = preload("res://conf/GLOBALS.gd")

const IDLE : int = 1

const MAXFRAMECOUNT : int = 3

onready var stats : Reference = get_node("Stats").stats

export var id : int = 0

var velocity = Vector2(0,0)

onready var player : KinematicBody2D = Utils.GetMainNode().get_node("Player")
onready var flip : Node2D = $Flip
onready var sprite : Sprite = get_node("Flip/Sprite")

export var directionSmooth : float = 1
export var changeDirectionEase : float = 1

var playerDistance : float
var isFollowing : bool = false
var direction : int = 1
var playerInAttackRange : bool = false
var followRange : float = 150.00

var count : int = 0

func _ready():
	sprite.frame = 0

func _physics_process(delta):
	FindAndFollowPlayer(delta)
	if isFollowing:
		velocity.x = GLOBALS.SPEED * direction

	if playerInAttackRange:
		Attack()

	velocity.y += GLOBALS.GRAVITY
	AnimationHandler()
	velocity = move_and_slide(velocity, GLOBALS.FLOOR)


func FindAndFollowPlayer(delta):
	if player != null:
		playerDistance = player.get_position().x - get_position().x
		directionSmooth += (direction - directionSmooth) * delta * changeDirectionEase
	
		# flip the direction the enemy is facing
		if velocity.x > 0.01:
			if flip.get_scale().x == -1:
				flip.set_scale(Vector2(1, 1))
		elif velocity.x < 0.01:
			if flip.get_scale().x == 1:
				flip.set_scale(Vector2(-1, 1))

		# check if the player is in range to follow
		# this may change based on enemy type and require gathering info from the database
		if abs(playerDistance) < followRange:
			isFollowing = true
		else:
			isFollowing = false;
		
		if isFollowing:
			if playerDistance < 0:
				direction = -1
			else:
				direction = 1
		else:
			directionSmooth = direction
	else:
		velocity.x = 0

# Handles the animation of the enemy
# Counts up in the frames resetting back to 0 when max frames are met
## Frames must not exceed 4 for use with this function
# TODO: Check if we can set the MAXFRAMECOUNT dynamically by the size of the frames
func AnimationHandler() -> void:
	if isFollowing:
		sprite.frame = count
		if count == MAXFRAMECOUNT:
			count = 0
		else:
			count += 1
	else:
		sprite.frame = 0 
	
func Attack():
	GLOBALS.TakeDamage(player.get_node("PlayerStats"), direction, stats.GetDamage())

func _on_Area2D_area_entered(area):
	match area.get_groups():
		[GLOBALS.PLAYER_GROUP]:
			playerInAttackRange = true

func _on_Area2D_area_exited(area):
	match area.get_groups():
		[GLOBALS.PLAYER_GROUP]:
			playerInAttackRange = false
