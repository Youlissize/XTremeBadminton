extends CharacterBody2D

const Globals := preload("res://MainLevel/Scripts/Main/globalStuff.gd")

# PARAMS
@export var speed := 800.0
@export var gravity := 1500
var jumpPreshotAcceptance := 0.1 * 1000 # in ms
@export var hitDelay := 0.25 * 1000 # in ms
var hitPreshotAcceptance := 0.15 * 1000 # in ms
@export var objectForce := 50

# INPUT
#signal leave
var player: int
var input

# utility
var inAir := true
var quickFall := false
var fallSpeed := 2.0
var onObject := false
var onObjectTimer := 0.0
var isLeftSide : bool = true
var X_dir := 0.0
var Y_speed := 0.0
var lastPressJumpTime := 0
var lastHitTime := 0
var hitBuffer := Vector2(0,0) # represents : timer count , type of hit pressed (0=nothing,1=base hit)
var minAngleToGround := 0.1
var isServing := false

#REFERENCES AUX TRUCS
var ground : StaticBody2D
var volant := Array()
var raquette : Node2D #preload("res://Player/Scripts/raquette_base.gd").new()
var anim : AnimationPlayer
var epaule : Node2D

# INITIALISATION BIDULES
func _ready() -> void:
	pass

# INPUTS
# call this function when spawning this player to set up the input object based on the device
func init(deviceInput : DeviceInput, isLeftSide : bool)->void:
	#player = player_num
	input = deviceInput
	#print("INIT : Player ", player_num, " with Device ",device)
	
	anim = get_node("AnimationPlayer")
	epaule = get_node("Epaule")
	raquette = get_node("Epaule/Raquette")
	raquette.player = self
	setSide(isLeftSide)

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
		$Perso.scale.x = -1.0 * abs($Perso.scale.x) # WARNING scale négative provoque probablement des bugs!
		$Epaule.scale.x = -1.0 * abs($Epaule.scale.x)
		Globals.currentMatch.teamLeft.erase(self)
		Globals.currentMatch.teamRight.append(self)
	if isLeft:
		$Perso.scale.x = abs($Perso.scale.x)
		$Epaule.scale.x = abs($Epaule.scale.x)
		Globals.currentMatch.teamRight.erase(self)
		Globals.currentMatch.teamLeft.append(self)

func teleport(newPos : Vector2)	:
	global_position = newPos

func _process(_delta):

	# Handle timer for the waiting "hit"
	if (hitBuffer.y > 0):
		hitBuffer.x -= _delta*1000
		if (hitBuffer.x<0):
			hit(true)
			hitBuffer = Vector2(0,0)
	if (onObjectTimer >0):
		onObjectTimer -= _delta
		if (onObjectTimer<0):
			onObject = false

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
		var c = collision.get_collider()
		#Tentative pour "pousser" les floating objects
		if (c):
			#print(c.get_class())
			if(c.get_class() == "RigidBody2D"):
				c.set("linear_velocity", -10.0*collision.get_normal()*objectForce + c.get("linear_velocity"))
				
				#c.set("angular_velocity", c.get("angular_velocity")*1.2)
		if(collision.get_collider()== Globals.ground):
			touchedGround()
		elif (collision.get_normal().y < -1.0*minAngleToGround):# && collision.get_collider().is_class(onFloatingObject())):
			onFloatingObject()
		elif (collision.get_normal().y > 0.5 && c.get_class() != "RigidBody2D"): # plafond
			Y_speed = 0
		else:
			motion = Vector2(0.0, Y_speed* delta)
			move_and_collide(motion)
	if (inAir):
		if (quickFall):
			Y_speed += gravity*delta*fallSpeed
		else:
			Y_speed += gravity*delta
				
	if(isServing):
		# teleport volant each frame until service
		Globals.projectiles[0].global_position = self.global_position + getForwardVector()*70+Vector2(0,-200)
		
func touchedGround():
	inAir=false
	quickFall = false
	Y_speed = 0
	# Check if 'jump' was hit just before
	if (Time.get_ticks_msec() < lastPressJumpTime + jumpPreshotAcceptance):
		jump()

func onFloatingObject():
	#return
	#Y_speed = 0
	#inAir=false
	quickFall = false
	Y_speed *= 0.8
	if (Time.get_ticks_msec() < lastPressJumpTime + jumpPreshotAcceptance):
		jump()
	onObject = true
	onObjectTimer = 0.5

func allowedToJump() -> bool:
	if(!inAir):
		return true
	elif (onObject):
		return true
	else:
		return false
			
func jump():
	if (allowedToJump()):
		lastPressJumpTime = 0
		quickFall = false
	else:
		lastPressJumpTime = Time.get_ticks_msec()

func startFalling():
	quickFall = true

func getForwardVector() -> Vector2:
	if isLeftSide:
		return Vector2(1,0)
	else:
		return Vector2(-1,0)

# TAPER DRU
func hit(ignoreTiming := false) -> bool:
	if (isServing):
		serve()
		return true
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

func serve():
	isServing = false
	Globals.projectiles[0].hitted(Vector2(0, -600))
	#TODO : petit lancé de balle
