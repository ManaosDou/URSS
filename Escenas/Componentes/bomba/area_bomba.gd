extends Area3D
class_name AreaBomba

func _on_body_entered(body):
	if body is Jugador:
		body.en_area_bomba = true
		body.bomba_label.visible = true

func _on_body_exited(body):
	if body is Jugador:
		body.en_area_bomba = false
		body.bomba_label.visible = false
