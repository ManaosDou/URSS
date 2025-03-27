extends ObjectoHackeable

@export var barrera : Node3D

func hack():
	barrera.queue_free()
