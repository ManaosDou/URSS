extends Node
class_name EnemyManager

@export var jugador : Jugador

enum fases {TRANQUILO, CAZA, ALERTA}
@export_enum("TRANQUILO","CAZA","ALERTA") var fase : int = fases.TRANQUILO

func _ready():
	fase = fases.TRANQUILO

func _process(delta: float) -> void:
	match fase:
		fases.TRANQUILO:
			jugador.fase_label.text = "Fase: Tranquilo"
		fases.CAZA:
			jugador.fase_label.text = "Fase: Caza"
		fases.ALERTA:
			jugador.fase_label.text = "Fase: Alerta"
