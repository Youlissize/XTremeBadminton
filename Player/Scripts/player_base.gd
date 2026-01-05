extends CharacterBody2D

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
	anim = get_node("AnimationPlayer")
	epaule = get_node("Epaule")
	
	raquette = get_node("Raquette")
	raquette.leftSide = isLeftSide

# INPUTS
func _input(_event: InputEvent) -> void:
	X_dir = Input.get_axis("move_left","move_right")
	
	if (Input.is_action_pressed("jump")):
		jump()
	elif (Input.is_action_pressed("hit")):
		hit()

# DEPLACEMENTS
func getMotion(delta:float) -> Vector2:
	return Vector2(speed * X_dir, Y_speed) * delta

func _physics_process(delta: float) -> void:
	var motion = getMotion(delta)
	
	var collision := move_and_collide(motion)
	if (collision != null):
		if(collision.get_collider()==ground):
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
