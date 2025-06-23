@tool
extends Area3D
class_name ObjetoDistractorioSonoro

@export var rango : float = 20
@export var collision : CollisionShape3D
@export var mesh : MeshInstance3D
@export var encendida : bool = false

func _physics_process(delta):
	if encendida:
		mesh.mesh.radius = rango
		collision.shape.radius = rango
	else:
		mesh.mesh.radius = 0
		collision.shape.radius = 0
