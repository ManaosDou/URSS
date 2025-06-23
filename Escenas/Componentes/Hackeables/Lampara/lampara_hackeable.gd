extends ObjectoHackeable
@export var apagada : bool = false
@export var area : Area3D 

func hack():
	if apagada == false:
		$"../LamparaPunta/OmniLight3D".visible = false
		$"../LamparaPunta".visible = false
		area.encendida = false
		apagada = true
	else:
		$"../LamparaPunta/OmniLight3D".visible = true
		$"../LamparaPunta".visible = true
		area.encendida = true
		apagada = false
