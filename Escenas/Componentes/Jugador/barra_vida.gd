extends Control

@export var rect_vida : ColorRect
@export var rect_cooldown : ColorRect
var vida = 100
var cooldown = 100

func _process(delta: float) -> void:
	rect_vida.size.x = remap(vida,0,100,0,317)
	rect_cooldown.size.x = remap(cooldown,0,100,0,105)
