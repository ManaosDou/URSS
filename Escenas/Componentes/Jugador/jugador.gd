extends CharacterBody3D
class_name Jugador

@export var pasos_audio : AudioStreamPlayer3D
@export var pasos_audio_timer : Timer
@export var velocidad_normal : float = 5
@export var velocidad_correr : float = 10
@export var velocidad_agachado : float = 3
@export var mouse_sens : float = 0.001
@onready var camera : Camera3D = get_node("Camera3D")
@export var arma_flash : GPUParticles3D
@export var arma_animacion : AnimationPlayer
@export var hud : Control
@export var objeto_detectado : Marker3D
@export var radar : Control
@export var fase_label : Label
@export var hacking_cooldown : Timer
@export var hacking_cooldown_bar : ProgressBar

var quiere_correr

var agachado : bool 
@export var agacharse_animacion : AnimationPlayer

var municion_en_arma : int = 10
var max_municion_en_arma : int = 10
var municion_de_reserva : int = 2
var max_municion_de_reserva : int = 10

var puntos_de_experiencia : int = 0

var vida : int = 100
var max_vida : int = 100

var stamina : float = 100
var max_stamina : float = 100
var velocidad : float = velocidad_normal
var tiempo_sin_correr : float = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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
	quiere_correr = Input.is_action_pressed("correr") and stamina > 0 and agachado == false
	
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
	
	

	if velocity.length() > 0 and is_on_floor():
		if pasos_audio_timer.is_stopped():
			pasos_audio_timer.start()
	else: pasos_audio_timer.stop()

	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = 500 * delta
		Globals.nivel.triggers.jugador_salto = true
	if not is_on_floor():
		velocity.y -= 15 * delta

	# Arma
	if Input.is_action_just_pressed("disparar") and not arma_animacion.is_playing() and municion_en_arma > 0:
		arma_animacion.play("disparar")
		municion_en_arma -= 1
		detectar_enemigo()
	if Input.is_action_just_pressed("recargar"):
		recargar()

	# HUD
	hud.municion = municion_en_arma
	hud.max_municion = municion_de_reserva
	if "stamina" in hud:
		hud.stamina = stamina
		hud.max_stamina = max_stamina

	move_and_slide()
	detectar_hackeo()

func _process(delta: float) -> void:
	hacking_cooldown_bar.max_value = hacking_cooldown.wait_time
	hacking_cooldown_bar.value = hacking_cooldown.wait_time - hacking_cooldown.time_left

func detectar_enemigo():
	var collider = get_node("Camera3D/RayCast3D").get_collider()
	if collider is Guardia or collider is Cientifico:
		var es_headshot = false
		collider.disparo(es_headshot)


func detectar_hackeo():
	var collider = get_node("Camera3D/RayCast3D").get_collider()
	if collider is ObjectoHackeable and hacking_cooldown.is_stopped():
		$CanvasLayer/HackingLabel.visible = true
		if Input.is_action_just_pressed("hackear"):
			collider.hack()
			hacking_cooldown.start()
	else:
		$CanvasLayer/HackingLabel.visible = false

func _input(event):
	if event is InputEventMouseMotion:
		camera.rotation.x = camera.rotation.x - event.relative.y * 0.008
		camera.rotation.y = camera.rotation.y - event.relative.x * 0.008
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x,-90,90)

func recargar():
	if municion_en_arma < max_municion_en_arma and municion_de_reserva > 0:
		var balas_necesarias = max_municion_en_arma - municion_en_arma
		var balas_a_recargar = min(balas_necesarias, municion_de_reserva)
		municion_en_arma += balas_a_recargar
		municion_de_reserva -= balas_a_recargar
		arma_animacion.play("recargar")

func recibir_dano(cantidad: int):
	vida -= cantidad
	if vida <= 0:
		vida = 0
		morir()

func morir():
	pass

func _on_timer_timeout() -> void:
	var velocidad_pasos = 0.75
	var velocidad_pasos_c = 0.5
	if quiere_correr: pasos_audio_timer.wait_time = velocidad_pasos_c
	else: pasos_audio_timer.wait_time = velocidad_pasos
	pasos_audio.play()
