extends CharacterBody3D
class_name Guardia

var velocidad : float = 5
var velocidad_caza : float = 5
var vida : int = 3
@export var distancia_vision : float = 8
@export var distancia_disparo : float = 8
@export var velocidad_rotacion : float = 5

@export var timer_espera_patrulla : Timer
@export var tiempo_espera : float = 2
var esperando_en_punto : bool = false

@export var lista_puntos : Array[Node]
var indice_punto : int = 0

var ultima_posicion_jugador : Vector3
@export var timer_disparo : Timer
@export var tiempo_entre_disparos : float = 3
@export var dano_disparo : int = 20

@export var agent : NavigationAgent3D
@export var raycast : RayCast3D

@export var jugador : Jugador

func _ready() -> void:
	timer_espera_patrulla.wait_time = tiempo_espera
	timer_espera_patrulla.timeout.connect(_on_timer_espera_timeout)
	
	timer_disparo.wait_time = tiempo_entre_disparos
	timer_disparo.timeout.connect(_on_timer_disparo_timeout)
	
	agent.target_position = lista_puntos[indice_punto].global_position

func _physics_process(delta: float) -> void:
	match Globals.nivel.estado_alerta:
		Globals.nivel.Alerta: procesar_alerta(delta)
		Globals.nivel.Caza: procesar_caza(delta)
		Globals.nivel.Patrulla: procesar_patrulla(delta)
	procesar_estados()

func rotar_hacia_direccion(direccion: Vector3, delta: float):
	if direccion.length() > 0.1:  
		var direccion_horizontal = Vector3(direccion.x, 0, direccion.z).normalized()
		var target_transform = transform.looking_at(global_position + direccion_horizontal, Vector3.UP)
		
		transform = transform.interpolate_with(target_transform, velocidad_rotacion * delta)

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

func procesar_estados():
	if esta_jugador_en_foco():
		if Globals.nivel.estado_alerta != Globals.nivel.Caza:
			Globals.nivel.activar_estado_caza()
		else:
			Globals.nivel.resetear_timer_caza()
		
		ultima_posicion_jugador = jugador.global_position
		
		if Globals.nivel.estado_alerta == Globals.nivel.Caza:
			agent.target_position = jugador.global_position

func procesar_patrulla(delta: float):
	agent.target_position = lista_puntos[indice_punto].global_position
	
	if esperando_en_punto:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	var distancia_a_punto : Vector3 = global_position.direction_to(agent.get_next_path_position())
	
	velocity = distancia_a_punto.normalized() * velocidad
	velocity.y = 0
	rotar_hacia_direccion(distancia_a_punto, delta)
	move_and_slide()
	
	if global_position.distance_to(agent.target_position) < 1:
		esperando_en_punto = true
		timer_espera_patrulla.start()

func procesar_alerta(delta: float):
	agent.target_position = ultima_posicion_jugador
	
	var distancia_a_punto : Vector3 = global_position.direction_to(agent.get_next_path_position())
	if global_position.distance_to(agent.target_position) > 1:
		velocity = distancia_a_punto.normalized() * velocidad
		velocity.y = 0
		rotar_hacia_direccion(distancia_a_punto, delta)
	else: 
		velocity = Vector3.ZERO 
	move_and_slide()

func procesar_caza(delta: float):
	var distancia_a_jugador = global_position.distance_to(jugador.global_position)
	
	# Si está dentro de la distancia de disparo, detenerse y disparar
	if distancia_a_jugador <= distancia_disparo:
		# Rotar hacia el jugador
		var direccion_a_jugador = global_position.direction_to(jugador.global_position)
		rotar_hacia_direccion(direccion_a_jugador, delta)
		
		# Disparar si puede
		if timer_disparo.is_stopped():
			disparar_a_jugador()
			timer_disparo.start()
		
		velocity = Vector3.ZERO
	else:
		# Si está lejos, acercarse al jugador
		agent.target_position = jugador.global_position
		var distancia_a_punto : Vector3 = global_position.direction_to(agent.get_next_path_position())
		velocity = distancia_a_punto.normalized() * velocidad_caza
		velocity.y = 0
		rotar_hacia_direccion(distancia_a_punto, delta)
	
	move_and_slide()

func disparar_a_jugador():
	jugador.recibir_dano(dano_disparo)

func _on_timer_espera_timeout():
	esperando_en_punto = false
	indice_punto += 1
	if indice_punto >= lista_puntos.size():
		indice_punto = 0
	agent.target_position = lista_puntos[indice_punto].global_position

func _on_timer_disparo_timeout():
	# El timer de disparo se resetea automáticamente
	pass

func disparo(headshot : bool = false):
	if headshot: 
		morir()
	else:
		vida -= 1
		if vida <= 0:
			morir()

func morir():
	queue_free()
