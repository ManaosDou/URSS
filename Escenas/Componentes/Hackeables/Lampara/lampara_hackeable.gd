extends ObjectoHackeable
@export var apagada : bool = false

func hack():
	if apagada == false:
		$"../LamparaPunta/OmniLight3D".visible = false
		$"../LamparaPunta".visible = false
		apagada = true
	else:
		$"../LamparaPunta/OmniLight3D".visible = true
		$"../LamparaPunta".visible = true
		apagada = false
