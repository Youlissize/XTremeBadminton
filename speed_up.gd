extends "res://MainLevel/MapObjects/PowerUps/power_up_base.gd"

@export var strength := 0.5

func hit(projectile : PhysicsBody2D) -> void:
	projectile.set("linear_velocity", projectile.get("linear_velocity") * (1.0+strength))
	
