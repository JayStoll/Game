# player controller script

extends KinematicBody2D


############ Variables #################
var GLOBALS : Reference = preload("res://conf/GLOBALS.gd")

onready var stats : Reference = get_node("PlayerStats").stats

# how high the player can jump
# to jump upwards - this value must be negative
const JUMP_POWER : int = -355
# set the dash amount
const DASH_SPEED : int = 30
# cool down on the dash
const DASH_CD : float = 1.5
# attack cd
const ATTACK_CD : float	= 0.05

var velocity : Vector2 = Vector2(0, 0)
var hasJumped : bool = false
var hasDashed : bool = false
# see if we are able to dash through a colliding object
var canDashThrough : bool = false

# attack
var attackDirection : int = 1
onready var attackCollision : CollisionShape2D = get_node("Attack_Area/CollisionShape2D")
# 1 this will remain positive on -1 this will become a negative
const COLLIDERPOS : int = 65
var isAttacking : bool = false
# tell us if we are hitting something that can take damage
var canAttack : bool = false

# timer
var timer : Timer = null
var attackTimer : Timer = null


############## entry point #####################
func _ready():
	# create timer for dash cooldown
	timer = Timer.new() 
	timer.set_one_shot(true)
	timer.set_wait_time(DASH_CD)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)

	# once animation is added this will be removed
	attackTimer = Timer.new() 
	attackTimer.set_one_shot(true)
	attackTimer.set_wait_time(ATTACK_CD)
	attackTimer.connect("timeout", self, "attack_on_timeout_complete")
	add_child(attackTimer)

# runs once every frame
func _physics_process(_delta):
	PlayerActions()



###############   Player Movement   #######################
func PlayerActions():
	# get the direction that we want to move the character
	var horizontalMovement = (int(Input.is_action_pressed("ui_right")) 
							- int(Input.is_action_pressed("ui_left")))
	velocity.x = horizontalMovement * GLOBALS.PLAYER_SPEED
	if horizontalMovement != 0:
		attackDirection = horizontalMovement
	
	# player functions
	Jump()
	Dash()
	Attack()
	
	# assigned velocity to the return of move_and_slide 
	# allows for gravity to be smooth and not pile up all at once
	# move_and_slide does delta calculations for us
	velocity = move_and_slide(velocity, GLOBALS.FLOOR)
	$player_collider.disabled = false

# jump and gravity
func Jump():
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
func Dash():
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

func Attack():
	if Input.is_action_just_pressed("attack"):
		SetAttackDirection()
		StartAttack()
		attackTimer.start()

func SetAttackDirection():
	match attackDirection:
		1:
			attackCollision.position.x = COLLIDERPOS
		-1:
			attackCollision.position.x = -COLLIDERPOS

func DealDamage(area):
	if canAttack:
		GLOBALS.TakeDamage(area.get_parent().get_node("Stats"), attackDirection, stats.GetDamage())

func StartAttack():
	isAttacking = true
	attackCollision.disabled = false

# reset the attack information to be ready for next input
func AttackReset():
	isAttacking = false
	attackCollision.disabled = true

# Allow the character to dash after the timer is up
func on_timeout_complete():
	hasDashed = false

func attack_on_timeout_complete():
	AttackReset()

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
	if isAttacking:
		match area.get_groups():
			[GLOBALS.ENEMY_GROUP]:
				canAttack = true
				DealDamage(area)
