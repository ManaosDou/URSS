extends Skill

# Da la opcion de hackear los objetos de tipo camara.
# Al ser activado, la camara pasara a un estado de desactivacion
# de determinado tiempo [cooldown_time]
# Al terminar, la camara volvera a la normalidad.
# Solo una cierta cantidad de camaras [max_cams] puede ser activada 

var cooldown_time : float = 12.5
var max_cams : int = 1

var camaras_desactivadas : int = 0

func _ready() -> void:
	opciones_hackeo = {"Camara" : hackear_camara}

func hackear_camara(objeto : Node3D):
	if camaras_desactivadas < max_cams:
		camaras_desactivadas += 1
		objeto.activado = false
		await get_tree().create_timer(cooldown_time).timeout
		objeto.activado = true
		camaras_desactivadas -= 1
