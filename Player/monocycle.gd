extends Node2D


func _physics_process(delta: float) -> void:
	$Roue.apply_torque(cos(Time.get_ticks_msec()*0.001) * 10000000 )
	pass
	#var vec :Vector2= $Fourche/CollisionShape2D.global_position - $Selle/CollisionShape2D.global_position

	#$Fourche/Sprite2D.rotation = vec.angle()+PI/2.0
	#$Selle/Sprite2D.rotation = vec.angle()+PI/2.0
	
