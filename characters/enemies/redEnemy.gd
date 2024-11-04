extends CharacterBody2D

@export var redEnemyData: Resource

var direction = Vector2.RIGHT

@onready var animatedSprite = $AnimatedSprite2D
@onready var ledgeCheckRight: = $LedgeCheckRight
@onready var ledgeCheckLeft: = $LedgeCheckLeft

func _physics_process(delta: float) -> void:
	var found_wall = is_on_wall()
	var found_ledge = not ledgeCheckRight.is_colliding() or not ledgeCheckLeft.is_colliding()
	
	if found_wall or found_ledge:
		direction *= -1
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity = direction * redEnemyData.SPEED
	if direction == Vector2.RIGHT:
		animatedSprite.flip_h = true
	else:
		animatedSprite.flip_h = false

	move_and_slide()
