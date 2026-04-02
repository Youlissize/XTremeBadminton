extends Node2D

signal leave
#var isLeftSide:bool = true
var player_id : int
var device_id : int
var input : DeviceInput
var player_node
var player_scene = preload("res://Player/player_walking.tscn")
var isLeftSide : bool

enum playerState {SELECTION, READY, PLAYING}
var currentState = playerState.SELECTION


func init(player_num: int, device: int):
	player_id = player_num
	device_id = device
	input = DeviceInput.new(device)
	print("INIT : Player ", player_num, " with Device ",device)
	
	isLeftSide = player_id%2==0 #à droite si impair
	player_node = player_scene.instantiate()
	player_node.init(input, isLeftSide)
	add_child(player_node)
	
	
func desinit():
	print("DESINIT : Player ", player_id, " with Device ",device_id)
	player_node.desinit()
	remove_child(player_node)
	player_node.queue_free()

func setSide(newIsLeft:bool):
	isLeftSide = newIsLeft
	player_node.setSide(isLeftSide)
	if (isLeftSide):
		player_node.teleport(Vector2(randf_range(100, 500), 500))
	else:
		player_node.teleport(Vector2(randf_range(1500, 2000), 500))
	pass
	
func _input(_event: InputEvent) -> void:
		# Input execute
	if (input.is_action_just_pressed("jump")):
		$mainBox.visible = false
	
	if input.is_action_just_pressed("join"):
		# an alternative to this is just call PlayerManager.leave(player)
		# but that only works if you set up the PlayerManager singleton
		leave.emit(player_id)
	
	if input.is_action_just_pressed("R1"):
		setSide(false)
	if input.is_action_just_pressed("L1"):
		setSide(true)
