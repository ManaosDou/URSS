extends Area3D
class_name PickUp

var ya_recogido: bool = false

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if ya_recogido:
		return
	
	if body is Jugador:
		ya_recogido = true
		agarrar(body)
		queue_free()

func agarrar(jugador: Jugador):
	pass
