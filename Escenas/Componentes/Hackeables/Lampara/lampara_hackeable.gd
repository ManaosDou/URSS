	extends ObjectoHackeable
@export var apagada : bool = false
@export var area : Area3D 

func hack():
	if apagada == false:
		$"../LamparaPunta/OmniLight3D".visible = false
		$"../LamparaPunta".visible = false
		area.encendido = false
		apagada = true
	else:
		$"../LamparaPunta/OmniLight3D".visible = true
		$"../LamparaPunta".visible = true
		area.encendido = true
		apagada = false
		luz_audio.play()
