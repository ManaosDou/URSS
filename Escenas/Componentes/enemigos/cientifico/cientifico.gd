extends CharacterBody3D
class_name Cientifico

## Clase del cientifico. Inspirarse en el viejo script "res://Escenas/Componentes/enemigos/enemigo_clase.gd" para implementaciones.
## Sobre NavigationAgents: https://docs.godotengine.org/en/4.4/tutorials/navigation/navigation_using_navigationagents.html

var velocidad : float = 120
var vida : int = 2

@export var lista_puntos : Array[Node3D]
var indice_punto : int = 0
var area_segura : Node3D

var estado_alerta : int

@export var agent : NavigationAgent3D
@export var raycast : RayCast3D

func _ready() -> void:
	#setea la target_position inicial en relacion al primer item de la lista de puntos
	agent.target_position = lista_puntos[indice_punto].global_position

func _physics_process(delta: float) -> void:
	# hace que las funciones de procesamiento cambien en relacion al estado
	match Globals.nivel.estado_alerta:
		Globals.nivel.Alerta: procesar_alerta()
		Globals.nivel.Patrulla: procesar_patrulla()
	procesar_estados()

## Se llama para saber si el cientifico esta mirando al jugador
func esta_jugador_en_foco() -> bool:
	## IMPLEMENTAR ESTO!!!! -facu :D
	return false

## Procesa los cambios de estado. En el caso del cientifico, hace que vaya al estado de casa cuando ve al jugador, y va hacia el area segura.
func procesar_estados():
	if esta_jugador_en_foco():
		Globals.nivel.estado_alerta = Globals.nivel.Caza
		agent.target_position = area_segura.global_position

## Codigo que corre cada process frame mientras el estado sea de patrulla
func procesar_patrulla():
	# direccion al siguiente paso hacia la target_position
	var distancia_a_punto : Vector3 = global_position.direction_to(agent.get_next_path_position())
	
	#se mueve hacia esa direccion multiplicado por su velocidad
	velocity = distancia_a_punto.normalized() * velocidad
	velocity.y = 0
	
	#si la distancia a la target_position es menor a 1, ir al siguiente punto.
	if global_position.distance_to(agent.target_position) < 1:
		indice_punto += 1
		agent.target_position = lista_puntos[indice_punto].global_position

## Codigo que corre cada process frame mientras el estado sea de alerta
func procesar_alerta():
	# lo mismo que en procesar patrulla, pero va al area segura
	var distancia_a_punto : Vector3 = global_position.direction_to(agent.get_next_path_position())
	if global_position.distance_to(agent.target_position) > 1:
		velocity = distancia_a_punto.normalized() * velocidad
		velocity.y = 0
	else: velocity = Vector3.ZERO # quedarse quieto si ya llego al area segura

## Funcion que interpreta un disparo al cientifico.
func disparo(headshot : bool = false):
	if headshot: morir()
	else:
		vida -= 1
		if vida <= 0:
			morir()

## Funcion que debe ser llamada cuando muere el cientifico. Por ahora solo desaparece inmediatamente.
func morir():
	queue_free()
