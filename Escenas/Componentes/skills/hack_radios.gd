extends Skill

func _ready() -> void:
	opciones_hackeo = {"Radios" : hack_encender}
	
func hack_encender(objeto : Node3D):
	objeto.queue_free()
