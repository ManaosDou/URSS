extends CharacterBody3D
class_name Guardia_viejo
## Un guardia que persigue al jugador.

## Cantidad de vida del enemigo. Al llegar a 0 explota y dice pum.
var vida : int

##El estado de alerta implica el conocimiento de la presencia del jugador en la zona pero se desconoce su ubicación exacta
var estado_alerta : int

##Es una lista de puntos de control por los que se tiene que mover el enemigo para realizar el patrullaje
var lista_puntos : Array[Node3D]

##Indica a qué punto de la lista está yendo el guardia
var indice_punto : int = 0

##Es la función para que el guardia dispare al jugador 
func disparar_jugador():
	pass

##Esta función se usa para definir la acción del guardia cuando detecta al jugador
func esta_jugador_en_foco() -> bool:
	return false
