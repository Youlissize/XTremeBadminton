extends CharacterBody2D

#STATS
	#déplacements
var speed := 600.0
var jumpForce := 1000
var gravity := 1500
	#raquette et style de jeu mon gars
var minHitDist := 50.0
var maxHitDist := 300.0
var hitForce := 1500.0
var hitSafety := 0.5



#AUTRES
var isLeftSide : bool = true
var inAir := true
var X_dir := 0.0
var Y_speed := 0.0

#REFERENCES AUX TRUCS
var ground : StaticBody2D
var volant : PhysicsBody2D
var raquette
var anim : AnimationPlayer
var epaule : Node2D

# INITIALISATION BIDULES
func _ready() -> void:
	anim = get_node("AnimationPlayer")
	epaule = get_node("Epaule")

# INPUTS
func _input(_event: InputEvent) -> void:
	X_dir = Input.get_axis("move_left","move_right")
	
	if (Input.is_action_pressed("jump")):
		jump()
	elif (Input.is_action_pressed("hit")):
		hit()

# DEPLACEMENTS
func _physics_process(delta: float) -> void:
	var motion = Vector2(speed * X_dir, Y_speed) * delta
	
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
	if (!inAir):
		Y_speed = -jumpForce
		inAir = true

# TAPER DRU
func hit():
	var epauleToVolant : Vector2 = volant.global_position-epaule.global_position
	var dist = epauleToVolant.length()
	print(dist)
	if (dist>minHitDist && dist<maxHitDist):
		var enHaut : bool = epauleToVolant.y<0
		print(enHaut)
		
		#anim
		#if (enHaut):
		anim.play("frapperHaut")
		
		
		var raquetteHitDirection : Vector2 #la perpendiculaire à la raquette
		raquetteHitDirection = epauleToVolant.orthogonal().normalized()
		if ((isLeftSide && enHaut) || (!isLeftSide && !enHaut)):
			raquetteHitDirection.x *= -1;
		
		var hitDirection : Vector2 #direction du tir
		hitDirection = lerp(raquetteHitDirection,Vector2.UP, hitSafety).normalized()
		
		var hitStrength : float #puissance du tir
		hitStrength = volant.get("linear_velocity").length() + hitForce
		
		
		
		#volant.set("velocity", Vector2(0,-600))
		volant.set("linear_velocity", hitDirection*hitStrength)
