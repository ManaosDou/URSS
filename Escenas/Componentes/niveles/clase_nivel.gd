extends Node3D
class_name Nivel

var triggers : Dictionary = {"jugador_salto" : false}
enum {Patrulla,Alerta,Caza}
@export var estado_alerta = Patrulla

@export var timer_caza_a_alerta : Timer
@export var timer_alerta_a_patrulla : Timer
@export var tiempo_caza : float = 10
@export var tiempo_alerta : float = 10

func _ready() -> void:
	Globals.nivel = self
	
	print(estado_alerta)
	timer_caza_a_alerta = Timer.new()
	timer_caza_a_alerta.wait_time = tiempo_caza
	timer_caza_a_alerta.one_shot = true
	add_child(timer_caza_a_alerta)
	timer_caza_a_alerta.timeout.connect(_on_timer_caza_timeout)
	
	timer_alerta_a_patrulla = Timer.new()
	timer_alerta_a_patrulla.wait_time = tiempo_alerta
	timer_alerta_a_patrulla.one_shot = true
	add_child(timer_alerta_a_patrulla)
	timer_alerta_a_patrulla.timeout.connect(_on_timer_alerta_timeout)

func activar_estado_caza():
	estado_alerta = Caza
	timer_alerta_a_patrulla.stop()
	timer_caza_a_alerta.start()
	print(estado_alerta)

func resetear_timer_caza():
	if estado_alerta == Caza:
		timer_caza_a_alerta.start()
		print(estado_alerta)

func _on_timer_caza_timeout():
	if estado_alerta == Caza:
		estado_alerta = Alerta
		timer_alerta_a_patrulla.start()
		print(estado_alerta)

func _on_timer_alerta_timeout():
	if estado_alerta == Alerta:
		estado_alerta = Patrulla
		print(estado_alerta)
