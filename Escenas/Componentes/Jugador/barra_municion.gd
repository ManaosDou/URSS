extends Control

@export var rect_mun : ColorRect

@export var jugador : Jugador

func _process(delta: float) -> void:
	rect_mun.size.y = remap(jugador.municion_en_arma,0,jugador.municion_de_reserva,250,1030)
	
