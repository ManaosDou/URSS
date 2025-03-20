extends CharacterBody3D

var velocidad : float = 10

func _ready():
	pass
	
func _process(delta):
	
		velocity.z = velocidad * Input.get_axis("mover_adelante","mover_atras")
		velocity.x= velocidad * Input.get_axis("mover_derecha","mover_izquierda")
		Input.get_axis("mover_adelante","mover_atras")
		Input.get_axis("mover_derecha","mover_izquierda")
		
		
	
		move_and_slide()
