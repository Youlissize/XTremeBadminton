extends "res://Player/Scripts/Raquettes/raquette_base.gd"

	#raquette et style de jeu mon gars
var minHitDist := 50.0
var maxHitDist := 200.0
var angleTopStart := 30.0
var angleTopEnd := 140.0
var angleBotStart := 80.0
var angleBotEnd := 170.0

var hitForce := 1500.0
var hitSafety := 0.2


func hitVolant(volant : PhysicsBody2D) -> bool:
	
	var epauleToVolant : Vector2 = volant.global_position- player.get_node("Epaule").global_position
	var enHaut : bool = epauleToVolant.y<0
	
	# Animation TODO : not play anim for each volant
	var animation = get_node("AnimationPlayer")
	if (animation):
		if (enHaut): 
			animation.play("hit")
		else:
			animation.play("hit_bas")
	
	
	#Test distance epaule-volant
	var dist = epauleToVolant.length()
	var s = volant.getRealSize()
	if (dist<minHitDist-s || dist>maxHitDist+ s):
		return false
	
	
	#Test angle epaule-volant
	var phi : float = epauleToVolant.angle_to(forward()) * 57.2957795131 #180/PI
	phi = 180 - abs(phi)
	print(phi)
	if ((enHaut && (phi>angleTopEnd || phi<angleTopStart))):
		return false
	if (!enHaut && (phi>angleBotEnd || phi<angleBotStart)):
		return false
	
	var raquetteHitDirection : Vector2 #la perpendiculaire à la raquette
	raquetteHitDirection = epauleToVolant.orthogonal().normalized()
	if ((leftSide && enHaut) || (!leftSide && !enHaut)):
		raquetteHitDirection *= -1;
	
	var hitDirection : Vector2 #direction du tir
	hitDirection = lerp(raquetteHitDirection,Vector2.UP, hitSafety).normalized()
	
	var hitStrength : float #puissance du tir
	hitStrength = volant.get("linear_velocity").length()*0.3 + hitForce
	
	volant.set("linear_velocity", hitDirection*hitStrength)
	volant.set("gravity_scale", 1) # TODO : remove this
	
	return true
