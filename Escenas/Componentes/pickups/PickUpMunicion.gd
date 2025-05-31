extends PickUp

func agarrar(jugador: Jugador):
	jugador.municion_de_reserva = min(jugador.municion_de_reserva + 10, jugador.max_municion_de_reserva)
