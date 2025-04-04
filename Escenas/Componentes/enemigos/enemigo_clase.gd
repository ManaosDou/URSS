extends CharacterBody3D
class_name Enemigo

@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
var speed = 5

func _physics_process(delta: float) -> void:
	nav_agent.target_position = $"../../Jugador".global_position
	var direction = position.direction_to(nav_agent.get_next_path_position())
	velocity = direction * speed
	move_and_slide()

func morir():
	queue_free()
