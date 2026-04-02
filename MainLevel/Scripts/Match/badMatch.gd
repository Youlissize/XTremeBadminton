extends Node

#var PlayerManager := preload("res://MainLevel/Scripts/Main/MainPlayerManager.gd").new()
const Globals := preload("res://MainLevel/Scripts/Main/globalStuff.gd")
var targetScore: int = 11
var pointDiff : int = 2

var teamLeft := Array()
var leftScore := 0
var teamRight := Array()
var rightScore := 0

enum matchState {SELECTION, BEGINNING, SERVING, PLAYING, PAUSED, FINISHED}
var state = matchState.SELECTION



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

# event called by Player who served -> TODO
func _onServe() -> void:
	state = matchState.PLAYING


func begin() -> void:
	state = matchState.BEGINNING
	# TODO :animations and give service
	#...
	giveServe(true)

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
		var proj = Globals.projectiles[0]
		proj.teleportForService(Vector2(500,500))
		return
	var targetLocation = Vector2(serveur.global_position.x, 550.0)
	if (Globals.projectiles.size()):
		var proj = Globals.projectiles[0]
		proj.teleportForService(targetLocation)
		serveur.isServing = true
