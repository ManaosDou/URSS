extends Area3D

@export var texto_nota : String = "Texto"

func _on_body_entered(body: Node3D) -> void:
	if body is Jugador:
		body.mostrar_texto_nota(texto_nota)

func _on_body_exited(body: Node3D) -> void:
	if body is Jugador:
		body.ocultar_texto_nota()
