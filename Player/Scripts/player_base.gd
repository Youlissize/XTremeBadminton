extends CharacterBody2D

var inAir := true
var X_dir := 0.0
var Y_speed := 0.0
var speed := 200.0
var jumpForce := 600
var gravity := 1000

func _ready() -> void:
	print("Bonjour")
	
func _physics_process(delta: float) -> void:
	var motion = Vector2(speed * X_dir, Y_speed) * delta
	
	var collision := move_and_collide(motion)
	if (collision != null):
		#print(collision.get_normal())
		if (collision.get_normal().x == 0.0):
			Y_speed = 0
			#if (collision.get_normal().y >0.0)
				
		else:
			motion = Vector2(0.0, Y_speed* delta)
			move_and_collide(motion)
	Y_speed += gravity*delta
	print(Y_speed)
		
	
	
	
func _input(event: InputEvent) -> void:
	X_dir = Input.get_axis("move_left","move_right")
	if (Input.is_action_pressed("jump")):
		Y_speed = -jumpForce
