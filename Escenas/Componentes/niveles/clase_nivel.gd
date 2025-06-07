extends Node3D
class_name Nivel

var triggers : Dictionary = {"jugador_salto" : false}
enum {Patrulla,Alerta,Caza}
@export var estado_alerta = Patrulla

func _ready() -> void:
	Globals.nivel = self
