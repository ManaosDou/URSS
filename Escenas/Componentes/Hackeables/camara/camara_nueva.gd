extends ObjectoHackeable

@export var apagada : bool = false

var jugador_detectado : bool = false
var jugador

@export var timer_apagada : Timer
@export var tiempo_espera : float = 2

func _ready() -> void:
	timer_apagada.wait_time = tiempo_espera
	timer_apagada.timeout.connect(_on_timer_apagada_timeout)

func _process(delta: float) -> void:
	if apagada == false:
		for collider in $CamaraDeteccion.get_overlapping_bodies():
			if collider is Jugador and not jugador_detectado:
				jugador_detectado = true
				jugador = collider
		if jugador_detectado:
			Globals.nivel.activar_estado_caza()
			look_at(jugador.position)
	

func hack():
	if apagada == false:
		apagada = true

func _on_timer_apagada_timeout():
	apagada = false
