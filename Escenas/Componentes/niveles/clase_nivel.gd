extends Node3D
class_name Nivel

var triggers : Dictionary = {"jugador_salto" : false}
enum {Patrulla,Alerta,Caza}
var estado_alerta = Patrulla
