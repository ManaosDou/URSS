extends Skill

func _ready() -> void:
	opciones_hackeo = {"Luz" : hack_explotar_luz}

func hack_explotar_luz(objeto : Node3D):
	objeto.queue_free()
