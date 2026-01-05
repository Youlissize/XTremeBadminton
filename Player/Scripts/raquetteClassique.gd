extends "res://Player/Scripts/raquette_base.gd"

	#raquette et style de jeu mon gars
var minHitDist := 50.0
var maxHitDist := 300.0
var hitForce := 1500.0
var hitSafety := 0.5


func hitVolant(volant : PhysicsBody2D) -> bool:
	var epauleToVolant : Vector2 = volant.global_position-self.global_position
	var dist = epauleToVolant.length()
	print(dist)
	if (dist<minHitDist || dist>maxHitDist):
		return false
		
	var enHaut : bool = epauleToVolant.y<0
	
	var raquetteHitDirection : Vector2 #la perpendiculaire à la raquette
	raquetteHitDirection = epauleToVolant.orthogonal().normalized()
	if ((leftSide && enHaut) || (!leftSide && !enHaut)):
		raquetteHitDirection.x *= -1;
	
	var hitDirection : Vector2 #direction du tir
	hitDirection = lerp(raquetteHitDirection,Vector2.UP, hitSafety).normalized()
	
	var hitStrength : float #puissance du tir
	hitStrength = volant.get("linear_velocity").length() + hitForce
	
	volant.set("linear_velocity", hitDirection*hitStrength)
	
	return true
