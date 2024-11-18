extends Node2D

enum {HOVER, FALL, LAND, RISE}

var state = HOVER

@onready var start_position = global_position
@onready var timer := $Timer
@onready var raycast := $RayCast2D
@onready var animatedSprite := $AnimatedSprite2D
@onready var particles := $GPUParticles2D


func _ready():
	timer.connect("timeout", Callable(self, "_on_timer_timeout"),CONNECT_DEFERRED) # Conectar la señal del temporizador

func _physics_process(delta: float) -> void:
	match state:
		HOVER: hover_state()
		FALL: fall_state(delta)
		RISE: rise_state(delta)
		
func hover_state() -> void:
	state = FALL
	
func fall_state(delta) -> void:
	animatedSprite.play("falling")
	position.y += 100 * delta
	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		position.y = collision_point.y
		state = LAND
		timer.start(1.0)
		particles.emitting = true

func rise_state(delta) -> void:
	particles.emitting = false
	animatedSprite.play("raising")
	position.y = move_toward(position.y, start_position.y, 25 * delta)
	if position.y == start_position.y:
		state = HOVER

func _on_timer_timeout():
	if state == LAND:  # Asegurarse de que el estado actual es LAND
		state = RISE
