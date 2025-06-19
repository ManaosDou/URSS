extends Area3D
class_name PickUp

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body is Jugador:
		agarrar(body)

func agarrar(jugador: Jugador):
	pass
