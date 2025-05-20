extends Skill

func _ready() -> void:
	opciones_hackeo = {"Puertas" : hack_abrir}
	
func hack_abrir(objeto : Node3D):
	objeto.queue_free()
