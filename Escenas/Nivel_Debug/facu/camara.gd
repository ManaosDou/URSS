extends Node3D

var activado : bool = true

var jugador_detectado : bool = false
var jugador

func _process(delta: float) -> void:
	for collider in $CamaraDeteccion.get_overlapping_bodies():
		if collider is Jugador and not jugador_detectado:
			$AnimationPlayer.play("jugador_detectado")
			jugador_detectado = true
			jugador = collider
	if jugador_detectado:
		look_at(jugador.position)
	
