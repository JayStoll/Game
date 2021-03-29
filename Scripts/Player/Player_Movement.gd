# player controller script

extends KinematicBody2D

############ Variables #################
var GLOBALS : Reference = preload("res://conf/GLOBALS.gd")

onready var stats : Reference = get_node("PlayerStats").stats
onready var playerSprite : Sprite = get_node("Sprite")
onready var animation : AnimationPlayer = get_node("AnimationPlayer")

# how high the player can jump
# to jump upwards - this value must be negative
const JUMP_POWER : int = -355
# set the dash amount
const DASH_SPEED : int = 30
# cool down on the dash
const DASH_CD : float = 1.5
# attack cd
const ATTACK_CD : float	= 0.05

var velocity : Vector2 = Vector2.ZERO
var hasJumped : bool = false
var hasDashed : bool = false
# see if we are able to dash through a colliding object
var canDashThrough : bool = false


#### Animation Handle
var isWalking : bool = false
var isAttacking : bool = false
var animationStateMachine : AnimationNodeStateMachinePlayback


############# attack vaiables ##################
# which direction the collider will have to face
var attackDirection : int = 1
onready var attackCollision : CollisionShape2D = get_node("Attack_Area/CollisionShape2D")
# get the position of the colider --- will be the same as Attack_Area/CollisionShape2D x position 
const COLLIDERPOS : int = 15
# timer
var timer : Timer = null


########### State Machine ##############
var currentState = null

onready var States = {
	"Idle"     : $States/Idle,
	"Walk"     : $States/Walk,
	"Attack"   : $States/Attack,
	"Dash"     : $States/Dash,
	"Jump"     : $States/Jump,
	"Falling"  : $States/Falling
}


############## entry point #####################
func _ready():
	animationStateMachine = $AnimationTree.get("parameters/playback")
	animationStateMachine.start("Idle")

	ChangeState("Idle")

	# create timer for dash cooldown
	timer = Timer.new() 
	timer.set_one_shot(true)
	timer.set_wait_time(DASH_CD)
	var _temp = timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)

# runs once every frame
func _physics_process(delta):
	var updateState = currentState.HandleInput(self, delta)
	if updateState != null:
		ChangeState(updateState)


func ChangeState(newState):
	currentState = States[newState]
	print(currentState.name)

###############   Player Movement   #######################
func PlayerActions() -> void:
	

	# player functions
	Jump()
	Dash()
	Attack()
	
	# assigned velocity to the return of move_and_slide 
	# allows for gravity to be smooth and not pile up all at once
	# move_and_slide does delta calculations for us
	velocity = move_and_slide(velocity, GLOBALS.FLOOR)
	$player_collider.disabled = false
	isAttacking = false
		
# jump and gravity
func Jump() -> void:
	if Input.is_action_pressed("ui_up"):
		if hasJumped == true:
			velocity.y = JUMP_POWER
			hasJumped = false
	
	# set the gravity tick
	velocity.y += GLOBALS.GRAVITY
	
	if is_on_floor():
		hasJumped = true
	else:
		hasJumped = false

# dash logic
func Dash() -> void:
	if Input.is_action_pressed("dash") && !hasDashed:
		# set the dash speed 
		velocity.x *= DASH_SPEED
		
		# let us know that we can't dash
		hasDashed = true
		# disable the collider so that the
		# player can go through the wall
		if canDashThrough:
			$player_collider.disabled = true;
		# start the dash cooldown timer
		timer.start()

func Attack() -> void:
	SetAttackDirection()
	if Input.is_action_just_pressed("attack"):
		isAttacking = true
	

func SetAttackDirection() -> void:
	FlipPayerSprite()
	match attackDirection:
		1:
			attackCollision.position.x = COLLIDERPOS
		-1:
			attackCollision.position.x = -COLLIDERPOS

func DealDamage(area) -> void:
	GLOBALS.TakeDamage(area.get_parent().get_node("Stats"), attackDirection, stats.GetDamage())

# used to flip the player sprite
# here so I dont have to repeat myself
func FlipPayerSprite():
	playerSprite.set_scale(Vector2(attackDirection, 1))

# Allow the character to dash after the timer is up
func on_timeout_complete():
	hasDashed = false

func _on_Area2D_area_entered(area):
	match area.get_groups():
		[GLOBALS.DASH_THROUGH_GROUP]:
			canDashThrough = true
		[GLOBALS.OUT_OF_BOUNDS_GROUP]:
			# play death sounds and reset game
			queue_free()

func _on_Area2D_area_exited(area):
	match area.get_groups():
		[GLOBALS.DASH_THROUGH_GROUP]:
			canDashThrough = false


func _on_Attack_Area_area_entered(area):
	match area.get_groups():
		[GLOBALS.ENEMY_GROUP]:
			DealDamage(area)
