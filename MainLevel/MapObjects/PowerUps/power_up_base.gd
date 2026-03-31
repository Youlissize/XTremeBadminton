extends StaticBody2D

@export var radius := 100.0
var oneTimePowerUp = true
var overrideTrajectory := false
var addForce := true

func _ready() -> void:
	$CollisionShape2D.scale = Vector2(radius*0.1, radius*0.1)

func hit(projectile : PhysicsBody2D)->void:
	if (!oneTimePowerUp):
		if (projectile.currentPowerUps.has(self)):
			return
		print("POWER UP! (", self.name, ")" )
		projectile.currentPowerUps.append(self)
	else:
		print("POWER UP! (", self.name, ")" )
		
	
func exit(projectile : PhysicsBody2D)->void:
	var i = projectile.currentPowerUps.find(self)
	if (i != -1):
		print("POWER UP EXIT")
		projectile.currentPowerUps.remove_at(i)

	
func getPowerUpForce(projectile : PhysicsBody2D) -> Vector2:
	# return Vector2(0, 0)
	return Vector2(0,-1000)

func trajectory(pos : Vector2, vel : Vector2, delta : float) -> Vector4:
	return Vector4(pos.x + delta*1000, pos.y, vel.x, vel.y)
