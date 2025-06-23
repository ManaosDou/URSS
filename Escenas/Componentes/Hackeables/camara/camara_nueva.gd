extends ObjectoHackeable

@export var apagada : bool = false
@export var animacion_vigilar : AnimationPlayer

var jugador_detectado : bool = false
var jugador

@export var timer_apagada : Timer
@export var tiempo_espera : float = 10

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
			jugador_detectado = false

func hack():
	if apagada == false:
		apagada = true
		jugador_detectado = false
		animacion_vigilar.stop()
		timer_apagada.start()

func _on_timer_apagada_timeout():
	apagada = false
	jugador_detectado = false
	animacion_vigilar.play("vigilar")
