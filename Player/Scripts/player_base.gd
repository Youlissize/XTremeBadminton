extends CharacterBody2D

const Globals := preload("res://MainLevel/Scripts/globalStuff.gd")

# INPUT
signal leave
var player: int
var input

#STATS
	#déplacements
var speed := 600.0
var gravity := 1500




#AUTRES
var isLeftSide : bool = true
var inAir := true
var X_dir := 0.0
var Y_speed := 0.0

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
	
	# in my project, I got the device integer by accessing the singleton autoload PlayerManager
	# but for simplicity, it's not an autoload in this demo.
	# but I recommend making it a singleton so you can access the player data from anywhere.
	# that would look like the following line, instead of the device function parameter above.
	# var device = PlayerManager.get_player_device(player)
	input = DeviceInput.new(device)
	print("INIT : Player ", player_num, " with Device ",device)
	
	
	anim = get_node("AnimationPlayer")
	epaule = get_node("Epaule")
	raquette = get_node("Epaule/Raquette")
	raquette.player = self
	setSide(player_num%2==0) #à droite si impair
	
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

func _input(_event: InputEvent) -> void:
		# Input execute
	X_dir = input.get_axis("move_left","move_right")
	if (input.is_action_just_pressed("jump")):
		jump()
	#input.get_vector()
	#elif (input.is_action_just_released("jump")): 
	#	jump()
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
			inAir=false
			Y_speed = 0
		if (collision.get_normal().x == 0.0):
			Y_speed = 0
		else:
			motion = Vector2(0.0, Y_speed* delta)
			move_and_collide(motion)
	if (inAir):
		Y_speed += gravity*delta
				
func jump():
	pass

# TAPER DRU
func hit() -> bool:
	return raquette.hit()
