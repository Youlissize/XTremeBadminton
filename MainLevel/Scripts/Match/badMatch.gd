extends Node

const Globals := preload("res://MainLevel/Scripts/globalStuff.gd")
var targetScore: int = 11
var pointDiff : int = 2

var teamLeft := Array()
var leftScore := 0
var teamRight := Array()
var rightScore := 0

enum matchState {NONE, BEGINNING, SERVING, PLAYING, PAUSED, FINISHED}
var state = matchState.NONE



func _ready() -> void:
	Globals.currentMatch = self
	pass

# event called by projectile
func _onProjectileTouchedGround(projectile : Node2D) -> void:
	#TODO : check who wins the point, update score , check if win, 
	# delete temp porjectils, giveServe(winner)
	var leftWins = Globals.level.get_node("Filet").position.x < projectile.position.x
	if (leftWins):
		Globals.scoreDisplay.left +=1
	else:
		Globals.scoreDisplay.right +=1
	
	
	Globals.scoreDisplay.display()
	
	giveServe(leftWins)
	pass

# event called by Player who served
func _onServe() -> void:
	state = matchState.PLAYING


func begin() -> void:
	state = matchState.BEGINNING
	# TODO :animations
	pass

func giveServe(toLeftPlayer : bool = true) -> void:
	state = matchState.SERVING
	givePorjectileToServe(toLeftPlayer)
	# TODO : activate projectile
	
func givePorjectileToServe(toLeftPlayer : bool = true) -> void:
	# TODO : if multiples team member : alternate between each
	var serveur
	if ((toLeftPlayer || teamRight.size()==0) && teamLeft.size()>0) :
		serveur = teamLeft[0]
	elif (teamRight.size()>0):
		serveur = teamRight[0]
	else:
		serveur = Globals.level.get_node("Filet")
	if (!serveur):
		return
	var targetLocation = serveur.position + Vector2(0, -100)
	if (Globals.projectiles.size()):
		var proj = Globals.projectiles[0]
		
		var temp = proj.collision_mask
		proj.collision_mask = 0
		proj.move_and_collide(targetLocation-proj.position)
		proj.collision_mask = temp
		proj.set("linear_velocity",Vector2(0,0))
		proj.set("gravity_scale", 0)
		proj.isActive = true
