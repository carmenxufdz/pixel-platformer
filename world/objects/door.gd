extends Area2D

class_name Door

@export_file("*.tscn") var target_level : String

var player

func go_to_next_room() -> void:
	Transitions.play_exit_transition()
	get_tree().paused = true
	await Transitions.transition_completed
	Transitions.play_enter_transition()
	get_tree().paused = false
	get_tree().change_scene_to_file(target_level)
	

func _process(delta: float) -> void:
	if not player:
		return
	if not player.is_on_floor():
		return
	if Input.is_action_just_pressed("up"):
		if target_level.is_empty():
			return
		go_to_next_room()

func _on_Door_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	body.on_door = true
	player = body

func _on_Door_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	body.on_door = false
	player = null
	
