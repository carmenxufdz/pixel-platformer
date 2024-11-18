extends Resource
class_name PlayerData

# Usamos `@export` para que se puedan modificar desde el inspector
@export var FALL_THRESHOLD: float = 250.0
@export var MAX_JUMP_VELOCITY: float = -350.0
@export var MIN_JUMP_VELOCITY: float = -100.0
@export var SPEED: float = 100.0
@export var ACCELERATION: float = 1200.0
@export var DECELERATION: float = 800.0
@export var CLIMB_SPEED: float = 50
@export var DOUBLE_JUMP_COUNT: int = 1

@export var SKIN: Resource = preload("res://characters/player/skin/playerGreenSkin.tres")
