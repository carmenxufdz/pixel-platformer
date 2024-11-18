extends CanvasLayer

signal transition_completed

@onready var animationPlayer := $AnimationPlayer

func play_exit_transition():
	show()
	animationPlayer.play("ExitLevel")

func play_enter_transition():
	show()
	animationPlayer.play("EnterLevel")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	hide()
	Transitions.emit_signal("transition_completed")
