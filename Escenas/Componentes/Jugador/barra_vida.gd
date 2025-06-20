extends Control

@export var rect_vida : ColorRect
@export var rect_cooldown : ColorRect
@export var hacking_cooldown : Timer
@export var jugador : Jugador

func _process(delta: float) -> void:
	rect_vida.size.x = remap(jugador.vida,0,jugador.max_vida,0,319)
	rect_cooldown.size.x = remap(hacking_cooldown.time_left,0,hacking_cooldown.wait_time,109,0)
	
