extends Area3D
class_name PickUp

@export var audio_pickup : AudioStreamPlayer3D

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body is Jugador:
		audio_pickup.play()
		agarrar(body)
		

func agarrar(jugador: Jugador):
	pass
