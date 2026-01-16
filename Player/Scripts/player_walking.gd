extends "res://Player/Scripts/player_base.gd"

var jumpForce := 1000

func _ready() -> void:
	super._ready()
	jumpForce = 700


func jump():
	if (!inAir):
		Y_speed = -jumpForce
		inAir = true


func hit() ->bool:
	var res = super.hit()
	#anim.play("frapperHaut")
	return res
