extends ObjectoHackeable
@export var apagada : bool = false
@export var area : Area3D 
@export var timer_apagada : Timer
@export var tiempo_espera : float = 10

func _ready() -> void:
	timer_apagada = Timer.new()
	add_child(timer_apagada)
	timer_apagada.wait_time = tiempo_espera
	timer_apagada.timeout.connect(_on_timer_apagada_timeout)


func hack():
	if apagada == false:
		$"../LamparaPunta/OmniLight3D".visible = false
		$"../LamparaPunta".visible = false
		area.encendida = false
		apagada = true
		timer_apagada.start()

func _on_timer_apagada_timeout():
	$"../LamparaPunta/OmniLight3D".visible = true
	$"../LamparaPunta".visible = true
	area.encendida = true
	apagada = false
