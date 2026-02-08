extends CharacterBody2D

const Globals := preload("res://MainLevel/Scripts/globalStuff.gd")

# PARAMS
var speed := 600.0
var gravity := 1500
var jumpPreshotAcceptance := 0.1 * 1000 # in ms
var hitDelay := 0.25 * 1000 # in ms
var hitPreshotAcceptance := 0.1 * 1000 # in ms

# INPUT
signal leave
var player: int
var input

# utility
var inAir := true
var isLeftSide : bool = true
var X_dir := 0.0
var Y_speed := 0.0
var lastPressJumpTime := 0
var lastHitTime := 0
var hitBuffer := Vector2(0,0) # represents : timer count , type of hit pressed (0=nothing,1=base hit)

#REFERENCES AUX TRUCS
var ground : StaticBody2D
var volant := Array()
var raquette : Node2D #preload("res://Player/Scripts/raquette_base.gd").new()
var anim : AnimationPlayer
var epaule : Node2D

# INITIALISATION BIDULES
func _ready() -> void:
	position = Vector2(1000,500)
	pass

# INPUTS
# call this function when spawning this player to set up the input object based on the device
func init(player_num: int, device: int):
	player = player_num
	input = DeviceInput.new(device)
	print("INIT : Player ", player_num, " with Device ",device)
	
	
	anim = get_node("AnimationPlayer")
	epaule = get_node("Epaule")
	raquette = get_node("Epaule/Raquette")
	raquette.player = self
	setSide(player_num%2==0) #à droite si impair

func desinit() :
	var m = Globals.currentMatch
	if isLeftSide:
		m.teamLeft.remove_at(m.teamLeft.find(self) )
	else:
		m.teamRight.remove_at(m.teamRight.find(self) )

func setSide(isLeft : bool) -> void :
	isLeftSide = isLeft
	raquette.leftSide = isLeftSide
	if (!isLeft):
		scale = Vector2(-1,1)
	if isLeft:
		Globals.currentMatch.teamLeft.append(self)
	else:
		Globals.currentMatch.teamRight.append(self)

func _process(_delta):
	# let the player leave by pressing the "join" button
	if input.is_action_just_pressed("join"):
		# an alternative to this is just call PlayerManager.leave(player)
		# but that only works if you set up the PlayerManager singleton
		leave.emit(player)

	# Handle timer for the waiting "hit"
	if (hitBuffer.y > 0):
		hitBuffer.x -= _delta*1000
		if (hitBuffer.x<0):
			hit(true)
			hitBuffer = Vector2(0,0)

func _input(_event: InputEvent) -> void:
		# Input execute
	X_dir = input.get_axis("move_left","move_right")
	
	if (input.is_action_just_pressed("jump")):
		jump()
	elif (input.is_action_just_released("jump")):
		startFalling()
		
	elif (input.is_action_just_pressed("hit")):
		hit()

# DEPLACEMENTS
func getMotion(delta:float) -> Vector2:
	return Vector2(speed * X_dir, Y_speed) * delta

func _physics_process(delta: float) -> void:
	var motion = getMotion(delta)
	
	var collision := move_and_collide(motion)
	if (collision != null):
		if(collision.get_collider()== Globals.ground):
			touchedGround()
#		if (collision.get_normal().x == 0.0):
#			Y_speed = 0
		else:
			motion = Vector2(0.0, Y_speed* delta)
			move_and_collide(motion)
	if (inAir):
		Y_speed += gravity*delta
				
func touchedGround():
	inAir=false
	Y_speed = 0
	# Check if 'jump' was hit just before
	if (Time.get_ticks_msec() < lastPressJumpTime + jumpPreshotAcceptance):
		jump()
	
func allowedToJump():
	return !inAir
			
func jump():
	if (allowedToJump):
		lastPressJumpTime = 0
	else:
		lastPressJumpTime = Time.get_ticks_msec()

func startFalling():
	pass

# TAPER DRU
func hit(ignoreTiming := false) -> bool:
	var time = Time.get_ticks_msec()
	if (ignoreTiming || (time > lastHitTime + hitDelay)):
		lastHitTime = time
		return raquette.hit()
	else:
		var delay = lastHitTime + hitDelay - time
		if (delay < hitPreshotAcceptance):
			hitBuffer.x = delay
			hitBuffer.y = 1 # means "basic hit"
		return false
