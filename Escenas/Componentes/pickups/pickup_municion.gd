extends PickUp

func agarrar(jugador: Jugador):
	if jugador.municion_de_reserva == jugador.max_municion_de_reserva:
		pass
	else:
		jugador.municion_de_reserva = min(jugador.municion_de_reserva + 10, jugador.max_municion_de_reserva)
		queue_free()
