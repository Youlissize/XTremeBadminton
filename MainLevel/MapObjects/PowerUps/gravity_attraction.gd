extends "res://MainLevel/MapObjects/PowerUps/power_up_base.gd"


@export var attractivty := 1.0
@export var faloff := 10.0

func _ready() -> void:
	super._ready()
	oneTimePowerUp = false

func getPowerUpForce(projectile : PhysicsBody2D) -> Vector2:
	var center = self.global_position
	# return Vector2(0, 0)
	var v = center-projectile.global_position
	var r = v.length()
	if (r>radius || projectile.waitingForService):
		return Vector2(0,0)
		#exit(projectile) #not needed, just always active
	var vn = v.normalized()
	var dp = vn.dot(projectile.linear_velocity.normalized())*0.5 +0.5
	return attractivty* 30000 * pow((1-smoothstep(0, radius, r)),faloff) * (dp*dp*0.6+0.4) * vn
