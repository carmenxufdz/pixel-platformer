extends Path2D

enum ANIMATION_TYPE{
	LOOP,
	UP_AND_DOWN
}

@export var animationType: ANIMATION_TYPE
@export var speed: float = 1

@onready var animationPlayer: = $AnimationPlayer

	
func _ready():
	set_animation_type()

func set_animation_type() -> void:
	match animationType:
		ANIMATION_TYPE.LOOP: animationPlayer.play("LoopAnimation")
		ANIMATION_TYPE.UP_AND_DOWN: animationPlayer.play("UpAndDown")

func set_speed(value) -> void:
	speed = value
	animationPlayer.speed_scale = speed
