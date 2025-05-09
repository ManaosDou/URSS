extends CharacterBody3D
class_name Jugador

@export var velocidad_normal : float = 10
@export var velocidad_correr : float = 20
@export var velocidad_agachado : float = 3
@export var mouse_sens : float = 0.025
@onready var camera : Camera3D = get_node("Camera3D")
@export var arma_flash : GPUParticles3D
@export var arma_animacion : AnimationPlayer
@export var hud : Control
@export var objeto_detectado : Marker3D
@export var radar : Control
@export var fase_label : Label

var agachado : bool 
@export var agacharse_animacion : AnimationPlayer

@export var municion : int = 10
var max_municion : int = 10


var stamina : float = 100
var max_stamina : float = 100
var velocidad : float = velocidad_normal
var tiempo_sin_correr : float = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	radar.crear_punto(objeto_detectado, Color.RED)

func _physics_process(delta):
	# agacharse
	if Input.is_action_pressed("agachar"):
		agachado = true
		if agacharse_animacion.current_animation_position == 0:
			agacharse_animacion.play("agacharse")
	elif  agacharse_animacion.current_animation_position != 0 and not agacharse_animacion.is_playing(): 
		agachado = false
		agacharse_animacion.play_backwards("agacharse")
	if agachado: velocidad = velocidad_agachado
	else: velocidad = velocidad_normal
	
	# correr
	var quiere_correr = Input.is_action_pressed("correr") and stamina > 0 and agachado == false
	
	if quiere_correr:
		velocidad = velocidad_correr
		stamina -= 20 * delta
		if stamina < 0:
			stamina = 0
		tiempo_sin_correr = 0.0  
	else:
		velocidad = velocidad_normal
		if stamina < max_stamina:
			tiempo_sin_correr += delta
			if tiempo_sin_correr > 2.0:
				stamina += 10 * delta
				if stamina > max_stamina:
					stamina = max_stamina

	# Movimiento
	velocity.z = velocidad * Input.get_axis("mover_adelante","mover_atras")
	velocity.x = velocidad * Input.get_axis("mover_izquierda","mover_derecha")
	velocity = velocity.rotated(Vector3(0,1,0), camera.rotation.y)

	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = 500 * delta
	if not is_on_floor():
		velocity.y -= 15 * delta

	# Arma
	if Input.is_action_just_pressed("disparar") and not arma_animacion.is_playing() and municion > 0:
		arma_animacion.play("disparar")
		municion -= 1
		detectar_enemigo()
	if Input.is_action_just_pressed("recargar"):
		arma_animacion.play("recargar")

	# HUD
	hud.municion = municion
	hud.max_municion = max_municion
	if "stamina" in hud:
		hud.stamina = stamina
		hud.max_stamina = max_stamina

	radar.posicion_jugador = global_position
	radar.puntos_radar.rotation = camera.rotation.y

	move_and_slide()
	detectar_hackeo()

func detectar_enemigo():
	var collider = get_node("Camera3D/RayCast3D").get_collider()
	if collider is Enemigo:
		collider.morir()

func detectar_hackeo():
	var collider = get_node("Camera3D/RayCast3D").get_collider()
	if collider is ObjectoHackeable:
		$CanvasLayer/HackingLabel.visible = true
		if Input.is_action_just_pressed("hackear"):
			collider.hack()
	else:
		$CanvasLayer/HackingLabel.visible = false

func _input(event):
	if event is InputEventMouseMotion:
		camera.rotation.x = camera.rotation.x - event.relative.y * 0.05
		camera.rotation.y = camera.rotation.y - event.relative.x * 0.05
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x,-90,90)
