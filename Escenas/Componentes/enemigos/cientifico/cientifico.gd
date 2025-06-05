extends CharacterBody3D
class_name Cientifico

var velocidad : float = 120
var vida : int = 2

var lista_puntos : Array[Node3D]
var indice_punto : int = 0
var area_segura : Node3D

var estado_alerta : int

var agent : NavigationAgent3D

func _ready() -> void:
	agent.target_position = lista_puntos[indice_punto].global_position
	var guardia = Guardia.new()
	guardia.vida

func _physics_process(delta: float) -> void:
	match Globals.nivel.estado_alerta:
		Globals.nivel.Alerta: procesar_alerta()
		Globals.nivel.Patrulla: procesar_patrulla()
	procesar_estados()

func esta_jugador_en_foco() -> bool:
	return false

func procesar_estados():
	if esta_jugador_en_foco():
		Globals.nivel.estado_alerta = Globals.nivel.Caza
		agent.target_position = area_segura.global_position

func procesar_patrulla():
	var distancia_a_punto : Vector3 = global_position.direction_to(agent.get_next_path_position())
	
	velocity = distancia_a_punto.normalized() * velocidad
	velocity.y = 0
	
	if distancia_a_punto.length() < 1:
		indice_punto += 1
		agent.target_position = lista_puntos[indice_punto].global_position

func procesar_alerta():
	var distancia_a_punto : Vector3 = global_position.direction_to(agent.get_next_path_position())
	if distancia_a_punto.length() > 1:
		velocity = distancia_a_punto.normalized() * velocidad
		velocity.y = 0
	else: velocity = Vector3.ZERO

func disparo(headshot : bool = false):
	if headshot: morir()
	else:
		vida -= 1
		if vida <= 0:
			morir()

func morir():
	queue_free()
