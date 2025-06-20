extends ObjectoHackeable

@export var barrera : Node3D
@export var abierta : bool = false
@export var puerta_audio : AudioStreamPlayer3D

func hack():
	puerta_audio.play()
	if abierta == false:
		$AnimationPlayer.play("abrir_puerta")
		abierta = true
	else:
		$AnimationPlayer.play_backwards("abrir_puerta")
		abierta = false
