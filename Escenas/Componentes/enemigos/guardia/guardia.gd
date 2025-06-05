extends CharacterBody3D
class_name Guardia
## Un guardia que persigue al jugador.

## Cantidad de vida del enemigo. Al llegar a 0 explota y dice pum.
var vida : int

var estado_alerta : int

var lista_puntos : Array[Node3D]

var indice_punto : int = 0

func disparar_jugador():
	pass

func esta_jugador_en_foco() -> bool:
	return false
