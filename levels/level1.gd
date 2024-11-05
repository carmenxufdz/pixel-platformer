extends Node2D

const PlayerScene = preload("res://characters/player/player.tscn")

@onready var camera: = $Camera2D
@onready var player: = $Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect_camera(camera)
	Events.connect("player_died",Callable(self, "_player_died"),CONNECT_DEFERRED)


func _player_died() -> void:
	var new_player = PlayerScene.instantiate()
	add_child(new_player)
	new_player.connect_camera(camera)
