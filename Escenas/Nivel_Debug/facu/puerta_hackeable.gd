extends ObjectoHackeable

@export var barrera : Node3D

func hack():
	$AnimationPlayer.play("abrir_puerta")
