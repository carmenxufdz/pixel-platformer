class_name Player

extends CharacterBody2D

@export var playerData: Resource
enum { MOVE, CLIMB }

@onready var animatedSprite: = $AnimatedSprite2D
@onready var check: = $Check  # Suponiendo que tienes un Area2D o RayCast2D llamado ladderCheck
@onready var remoteTransform: = $RemoteTransform2D

var initial_player_y: float = 0.0
var state
var double_jump

var on_door = false

func _ready() -> void:
	initial_player_y = global_position.y  # Guardamos la posición Y inicial del jugador
	double_jump = playerData.DOUBLE_JUMP_COUNT
	state = MOVE
	# Cargar las animaciones del personaje al iniciar
	animatedSprite.sprite_frames = playerData.SKIN

func _physics_process(delta: float) -> void:
	match state:
		MOVE: move_state(delta)
		CLIMB: climb_state(delta)
		
	align_to_pixels()
	update_animation()
	
	if global_position.y > initial_player_y + playerData.FALL_THRESHOLD:
		player_die()

	move_and_slide()

func move_state(delta) -> void:
	if is_on_ladder():
		state = CLIMB
	apply_gravity(delta)
	handle_jump()
	move_horizontal(delta)

func climb_state(delta) -> void:
	if not is_on_ladder():
		state = MOVE
	climb(delta)
	move_horizontal(delta)

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_jump() -> void:
	if on_door:
		return
	if is_on_floor():
		double_jump = playerData.DOUBLE_JUMP_COUNT
		if Input.is_action_just_pressed("up"):
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = playerData.MAX_JUMP_VELOCITY
	else:
		if Input.is_action_just_released("up") and velocity.y < playerData.MIN_JUMP_VELOCITY:
			velocity.y = playerData.MIN_JUMP_VELOCITY
		if Input.is_action_just_pressed("up") and double_jump > 0:
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = playerData.MAX_JUMP_VELOCITY
			double_jump = -1

func move_horizontal(delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		# Aceleración cuando hay entrada del jugador
		velocity.x = move_toward(velocity.x, direction * playerData.SPEED, playerData.ACCELERATION * delta)
	else:
		# Desaceleración cuando no hay entrada
		velocity.x = move_toward(velocity.x, 0, playerData.DECELERATION * delta)

	# Voltear el sprite según la dirección
	if direction != 0:
		animatedSprite.flip_h = direction > 0

func climb(delta) -> void:
	var direction = Input.get_axis("up", "down")
	if direction != 0:
		velocity.y = move_toward(velocity.y, direction * playerData.CLIMB_SPEED, playerData.ACCELERATION * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, playerData.DECELERATION * delta)

func is_on_ladder() -> bool:
	var collider = check.get_collider()
	if not check.is_colliding() or not collider is Ladder:
		return false
	return true
		

func update_animation() -> void:
	if is_on_ladder() and (Input.is_action_pressed("up") or Input.is_action_pressed("down")):
		animatedSprite.play("run")
	elif not is_on_floor():
		animatedSprite.play("jump")
	elif abs(velocity.x) > 0:
		animatedSprite.play("run")
	else:
		animatedSprite.play("idle")
		

func player_die() -> void:
	# Reiniciar la escena actual
	SoundPlayer.play_sound(SoundPlayer.DIE)
	queue_free()
	Events.emit_signal("player_died")

func align_to_pixels() -> void:
	# Alinear posición a pixeles para evitar desenfoque en juegos de pixel art
	position.x = round(position.x)
	position.y = round(position.y)

func connect_camera(camera: Camera2D) -> void:
	remoteTransform.remote_path = camera.get_path()
