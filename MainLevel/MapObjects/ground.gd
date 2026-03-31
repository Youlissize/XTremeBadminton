extends StaticBody2D
const Globals := preload("res://MainLevel/Scripts/Main/globalStuff.gd")

func hit(projectile : Node2D) -> void : 
	projectile.isActive = false
	
	if (Globals.currentMatch):
		Globals.currentMatch._onProjectileTouchedGround(projectile)
