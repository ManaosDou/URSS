@tool
extends Area3D
class_name ObjetoDistractorioSonoro

@export var rango : float = 20
@export var collision : CollisionShape3D
@export var mesh : MeshInstance3D
@export var encendida : bool = false
@export var timer_distraccion : Timer
@export var tiempo_distraccion : float = 10
var enemigos_distraidos : Array = []

func _ready():
	timer_distraccion.wait_time = tiempo_distraccion
	timer_distraccion.timeout.connect(_on_timer_distraccion_timeout)


func _physics_process(delta):
	if encendida:
		mesh.mesh.radius = rango
		collision.shape.radius = rango
		if Globals.nivel.estado_alerta == Globals.nivel.Patrulla:
			distraer_enemigos()

	else:
		mesh.mesh.radius = 0
		collision.shape.radius = 0

func distraer_enemigos():
	var cuerpos = get_overlapping_bodies()
	
	for cuerpo in cuerpos:
		if (cuerpo is Guardia or cuerpo is Cientifico) and cuerpo not in enemigos_distraidos:
			enemigos_distraidos.append(cuerpo)
			distraer_enemigo(cuerpo)

func distraer_enemigo(enemigo):
	# Detener patrulla del enemigo
	enemigo.activar_distraccion(global_position)
	
	# Hacer que vaya hacia la radio
	enemigo.agent.target_position = global_position
	
	# Iniciar timer si no está corriendo
	timer_distraccion.start()

func _on_body_entered(body):
	if encendida and (body is Guardia or body is Cientifico):
		if Globals.nivel.estado_alerta == Globals.nivel.Patrulla:
			distraer_enemigo(body)

func _on_body_exited(body):
	if body in enemigos_distraidos:
		enemigos_distraidos.erase(body)

func _on_timer_distraccion_timeout():
	for enemigo in enemigos_distraidos:
		if is_instance_valid(enemigo):
			enemigo.desactivar_distraccion()
	
	enemigos_distraidos.clear()
	encendida = false
