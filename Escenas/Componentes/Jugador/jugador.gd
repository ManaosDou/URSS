extends CharacterBody3D

@export var velocidad : float = 10
@export var mouse_sens : float = 0.025
@onready var camera : Camera3D = get_node("Camera3D")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _physics_process(delta):
		velocity.z = velocidad * Input.get_axis("mover_adelante","mover_atras")
		velocity.x= velocidad * Input.get_axis("mover_izquierda","mover_derecha")
		velocity = velocity.rotated(Vector3(0,1,0),camera.rotation.y)
		if Input.is_action_just_pressed("saltar") and is_on_floor():
			velocity.y = 500 * delta
		if not is_on_floor():
			velocity.y -= 15 * delta
		move_and_slide()
		detectar_hackeo()

func detectar_hackeo():
	var collider = get_node("Camera3D/RayCast3D").get_collider()
	if collider is ObjectoHackeable:
		if Input.is_action_just_pressed("hackear"):
			collider.hack()

func _input(event):
	if event is InputEventMouseMotion:
		camera.rotation.x = camera.rotation.x - event.relative.y * 0.05
		camera.rotation.y = camera.rotation.y - event.relative.x * 0.05
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x,-90,90)
