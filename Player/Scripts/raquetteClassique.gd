extends "res://Player/Scripts/raquette_base.gd"

	#raquette et style de jeu mon gars
var minHitDist := 50.0
var maxHitDist := 250.0
var hitForce := 1500.0
var hitSafety := 0.2


func hitVolant(volant : PhysicsBody2D) -> bool:
	var epauleToVolant : Vector2 = volant.global_position-self.global_position
	
	var dist = epauleToVolant.length()
	var s = volant.getRealSize()
	if (dist<minHitDist-s || dist>maxHitDist+ s):
		return false
		
	var enHaut : bool = epauleToVolant.y<0
	
	var raquetteHitDirection : Vector2 #la perpendiculaire à la raquette
	raquetteHitDirection = epauleToVolant.orthogonal().normalized()
	if ((leftSide && enHaut) || (!leftSide && !enHaut)):
		raquetteHitDirection *= -1;
	
	var hitDirection : Vector2 #direction du tir
	hitDirection = lerp(raquetteHitDirection,Vector2.UP, hitSafety).normalized()
	
	var hitStrength : float #puissance du tir
	hitStrength = volant.get("linear_velocity").length()*0.3 + hitForce
	
	volant.set("linear_velocity", hitDirection*hitStrength)
	
	return true
