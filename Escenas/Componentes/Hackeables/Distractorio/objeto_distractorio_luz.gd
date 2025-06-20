@tool
extends Area3D
class_name ObjetoDistractorioLuz

@export var rango : float
@export var collision : CollisionShape3D
@export var encendida : bool = true

func _physics_process(delta):
	if encendida:
		collision.shape.radius = rango
	else:
		collision.shape.radius = 0
