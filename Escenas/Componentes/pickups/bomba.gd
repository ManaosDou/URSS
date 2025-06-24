extends PickUp

func agarrar(jugador: Jugador):
	jugador.tiene_bomba = true
	queue_free()
