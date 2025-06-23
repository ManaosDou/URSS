extends ObjectoHackeable
@export var audio : AudioStreamPlayer3D
@export var area : Area3D
@export var timer_distractor : Timer
@export var tiempo_distractor : float = 1

func _ready() -> void:
	timer_distractor.wait_time = tiempo_distractor
	timer_distractor.timeout.connect(_on_timer_distractor_timeout)

func hack():
	audio.play()
	timer_distractor.start()
	area.encendida = true
	

func _on_timer_distractor_timeout():
	area.encendida = false
