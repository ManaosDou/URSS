@tool
extends Area3D
class_name ObjetoDistractorioLuz

@export var rango : float
@export var collision : CollisionShape3D

func _physics_process(delta):
	collision.shape.radius = rango
