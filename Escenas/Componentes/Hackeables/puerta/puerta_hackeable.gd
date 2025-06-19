extends ObjectoHackeable

@export var barrera : Node3D
@export var abierta : bool = false

func hack():
	if abierta == false:
		$AnimationPlayer.play("abrir_puerta")
		abierta = true
	else:
		$AnimationPlayer.play_backwards("abrir_puerta")
		abierta = false
