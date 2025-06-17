extends CharacterBody3D
class_name Cientifico

## Clase del cientifico. Inspirarse en el viejo script "res://Escenas/Componentes/enemigos/enemigo_clase.gd" para implementaciones.
## Sobre NavigationAgents: https://docs.godotengine.org/en/4.4/tutorials/navigation/navigation_using_navigationagents.html

var velocidad : float = 5
var vida : int = 2
@export var distancia_vision : float = 5
@export var velocidad_rotacion : float = 5

var timer_espera_patrulla : Timer
@export var tiempo_espera : float = 2
var esperando_en_punto : bool = false

@export var lista_puntos : Array[Node]
var indice_punto : int = 0
@export var area_segura : Node3D

var estado_alerta : int

@export var agent : NavigationAgent3D
@export var raycast : RayCast3D

@export var jugador : Jugador

func _ready() -> void:
	#setea la target_position inicial en relacion al primer item de la lista de puntos
	agent.target_position = lista_puntos[indice_punto].global_position
	
	timer_espera_patrulla = Timer.new()
	timer_espera_patrulla.wait_time = tiempo_espera
	timer_espera_patrulla.one_shot = true
	add_child(timer_espera_patrulla)
	timer_espera_patrulla.timeout.connect(_on_timer_espera_timeout)

func _physics_process(delta: float) -> void:
	# hace que las funciones de procesamiento cambien en relacion al estado
	match Globals.nivel.estado_alerta:
		Globals.nivel.Alerta: procesar_alerta(delta)
		Globals.nivel.Caza: procesar_alerta(delta) #Un detalle mas, cuando entra al estado de caza tambien queremos que vaya al area segura, asi que lo puse aca tambien en el match. 
		Globals.nivel.Patrulla: procesar_patrulla(delta)
	procesar_estados()
	

func rotar_hacia_direccion(direccion: Vector3, delta: float):
	if direccion.length() > 0.1:  
		var direccion_horizontal = Vector3(direccion.x, 0, direccion.z).normalized()
		var target_transform = transform.looking_at(global_position + direccion_horizontal, Vector3.UP)
		
		transform = transform.interpolate_with(target_transform, velocidad_rotacion * delta)


## Se llama para saber si el cientifico esta mirando al jugador
func esta_jugador_en_foco() -> bool:
	if global_position.distance_to(jugador.global_position) < distancia_vision:
		raycast.enabled = true
		raycast.target_position = to_local(jugador.global_position)
		if raycast.get_collider() is Jugador:
			return true
		else:
			return false
	else:
		raycast.enabled = false
		return false

## Procesa los cambios de estado. En el caso del cientifico, hace que vaya al estado de casa cuando ve al jugador, y va hacia el area segura.
func procesar_estados():
	if esta_jugador_en_foco():
		if Globals.nivel.estado_alerta != Globals.nivel.Caza:
			Globals.nivel.activar_estado_caza()
		else:
			# Si ya esta en caza resetea el timer
			Globals.nivel.resetear_timer_caza()
		agent.target_position = area_segura.global_position

## Codigo que corre cada process frame mientras el estado sea de patrulla
func procesar_patrulla(delta: float):
	# Aca esta el codigo anterior de procesar_patrulla.
	# Aca copiaste la parte que utilizaba una manera distinta de sacar la lista de puntos usando los hijos de un nodo llamado Patrulla
	# Si te fijas, te vas a dar cuenta que todo el codigo que pusimos la clase pasada que se encarga del comportamiento del cientifico esta dentro de un if que siempre va a dar true.
	# Por ende, el navigation agent nunca asigna su target position, y nunca se asigna la direccion del cientifico tampoco
	# Ademas, un pequeño detalle que a mi tambien se me paso de largo, despues de asignar la velocity tampoco habia un move_and_slide(), que siempre tiene que aplicarse despues de declarar la velocity para que se mueva.
	#Ahora fijate si lo podes arreglar tambien en procesar_alerta()! 😄
	
	# Estas lineas de codigo aca abajo comentadas son sobras del codigo anterior que son innecesarias en la nueva implementacion y estaban deteniendo el resto del codigo de correr:
	#var patrulla : Node = get_node_or_null("Patrulla")
	#if patrulla:
		#if lista_puntos.size() == 0:
			#lista_puntos = patrulla.get_children()
			#lista_puntos.shuffle()
			#agent.target_position = lista_puntos.pop_front().position
		#else:

	# direccion al siguiente paso hacia la target_position
	agent.target_position = lista_puntos[indice_punto].global_position
	
	if esperando_en_punto:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	var distancia_a_punto : Vector3 = global_position.direction_to(agent.get_next_path_position())
	
	#se mueve hacia esa direccion multiplicado por su velocidad
	velocity = distancia_a_punto.normalized() * velocidad
	velocity.y = 0
	rotar_hacia_direccion(distancia_a_punto, delta)
	#print(distancia_a_punto)
	move_and_slide()
	#si la distancia a la target_position es menor a 1, ir al siguiente punto.
	if global_position.distance_to(agent.target_position) < 1:
		esperando_en_punto = true
		timer_espera_patrulla.start()

## Codigo que corre cada process frame mientras el estado sea de alerta
func procesar_alerta(delta: float):
	# lo mismo que en procesar patrulla, pero va al area segura
	
	var distancia_a_punto : Vector3 = global_position.direction_to(agent.get_next_path_position())
	if global_position.distance_to(agent.target_position) > 1:
		velocity = distancia_a_punto.normalized() * velocidad
		velocity.y = 0
		rotar_hacia_direccion(distancia_a_punto, delta)
	else: velocity = Vector3.ZERO # quedarse quieto si ya llego al area segura
	move_and_slide()

func _on_timer_espera_timeout():
	esperando_en_punto = false
	# Ir al siguiente punto
	indice_punto += 1
	if indice_punto >= lista_puntos.size():
		indice_punto = 0
	agent.target_position = lista_puntos[indice_punto].global_position

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
