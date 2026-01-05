extends Node2D
const Globals := preload("res://MainLevel/Scripts/globalStuff.gd")

var leftSide : bool
	
func isHitPossible(pos : Vector2) ->bool:
	return true

func hitVolant(volant : PhysicsBody2D) -> bool:
	var volantPos = volant.position
	if (!isHitPossible(volantPos)):
		return false
	return true
	
func hit() ->bool :
	var res = false
	for volant in Globals.volants:
		if(hitVolant(volant)):
			res = true
	return res
