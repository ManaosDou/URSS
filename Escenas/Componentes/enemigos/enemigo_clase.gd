extends CharacterBody3D
class_name Enemigo

@onready var manager : EnemyManager = get_parent()
@export var agent : NavigationAgent3D
@export var speed : float = 5
@export var raycast : RayCast3D

@export var distancia_vision : float = 15
@export var jugador : Node3D

var ciclo_patrulla : Array = []

@export var timer_ultima_vez_visto_jugador : Timer
var posicion_ultima_vez_visto_jugador : Vector3

func morir():
	queue_free()

func _physics_process(delta: float) -> void:
	var fase = manager.fase
	match fase:
		manager.fases.TRANQUILO:
			tranquilo_update(delta)
		manager.fases.ALERTA:
			alerta_update(delta)
		manager.fases.CAZA:
			caza_update(delta)
	#agent.target_position = jugador.global_position
	#var direction = position.direction_to(agent.get_next_path_position())
	#velocity = direction * speed
	#move_and_slide()
#
#func morir():
	#queue_free()

func esta_jugador_en_foco() -> bool:
	if global_position.distance_to(manager.jugador.global_position) < distancia_vision:
		raycast.enabled = true
		raycast.target_position = to_local(manager.jugador.global_position)
		if raycast.get_collider() is Jugador:
			return true
		else:
			return false
	else:
		raycast.enabled = false
		return false

func sortear_por_distancia_jugador(a,b):
	if a.global_position.distance_to(posicion_ultima_vez_visto_jugador) < b.global_position.distance_to(posicion_ultima_vez_visto_jugador):
		return true
	return false

func patrullar_alerta():
	var patrulla : Node = get_node_or_null("Patrulla")
	if patrulla:
		if ciclo_patrulla.size() == 0:
			ciclo_patrulla = patrulla.get_children()
			ciclo_patrulla.sort_custom(sortear_por_distancia_jugador)
			agent.target_position = ciclo_patrulla.pop_front().position
		else:
			var direction = global_position.direction_to(agent.get_next_path_position())
			velocity = direction * speed
			if global_position.distance_to(agent.target_position) < 1:
				agent.target_position = ciclo_patrulla.pop_front().position

func patrullar_random():
	var patrulla : Node = get_node_or_null("Patrulla")
	if patrulla:
		if ciclo_patrulla.size() == 0:
			ciclo_patrulla = patrulla.get_children()
			ciclo_patrulla.shuffle()
			agent.target_position = ciclo_patrulla.pop_front().position
		else:
			var direction = global_position.direction_to(agent.get_next_path_position())
			velocity = direction * speed
			if global_position.distance_to(agent.target_position) < 1:
				agent.target_position = ciclo_patrulla.pop_front().position

func caza_update(delta):
	if esta_jugador_en_foco():
		timer_ultima_vez_visto_jugador.start()
	agent.target_position = manager.jugador.global_position
	posicion_ultima_vez_visto_jugador = manager.jugador.global_position
	if global_position.distance_to(agent.target_position) < 5:
		velocity = Vector3(0,0,0)
	else:
		var direccion = global_position.direction_to(agent.get_next_path_position())
		velocity = direccion * speed * 1.25
	move_and_slide()

func alerta_update(delta):
	patrullar_alerta()
	if esta_jugador_en_foco():
		manager.fase = manager.fases.ALERTA
	move_and_slide()

func tranquilo_update(delta):
	if esta_jugador_en_foco():
		manager.fase = manager.fases.CAZA
		timer_ultima_vez_visto_jugador.start()
	patrullar_random()
	move_and_slide()

func _on_timer_timeout() -> void:
	match manager.fase:
		manager.fases.CAZA:
			manager.fase = manager.fases.ALERTA
			timer_ultima_vez_visto_jugador.start()
		manager.fases.ALERTA:
			manager.fase = manager.fases.TRANQUILO
