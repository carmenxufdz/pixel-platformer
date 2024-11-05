extends Area2D

@onready var animatedSprite: = $AnimatedSprite2D

var is_checked: bool = false

func _on_Checkpoint_body_entered(body: Node2D) -> void:
	if not body is Player : return
	animatedSprite.play("checked")
	
	if not is_checked:
		Events.emit_signal("hit_checkpoint", position)
		is_checked = true
