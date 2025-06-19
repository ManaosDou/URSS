extends PickUp

func agarrar(jugador: Jugador):
	if jugador.vida < jugador.max_vida:
		jugador.vida = jugador.max_vida
	else:
		ya_recogido = false
		return
