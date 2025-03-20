extends CharacterBody3D

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_pressed("mover_adelante"):
		velocity.z = -10
	else:
		velocity.z = 0
	move_and_slide()
