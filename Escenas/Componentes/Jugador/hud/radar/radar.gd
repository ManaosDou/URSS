extends CenterContainer

@export var texture : Texture
@export var radar_velocidad : float = 5
@export var zoom : float = 10
@export var puntos_radar : Control
@export var punto_jugador : TextureRect
@export var anim_player : AnimationPlayer
@export var aro : TextureRect
@export var offset : float = 0

var posicion_jugador : Vector3 = Vector3.ZERO
var objetos : Array
@export var distancia_sonar : float = 256

func crear_punto(nodo : Node3D, color : Color):
	var punto = TextureRect.new()
	puntos_radar.add_child(punto)
	punto.texture = texture
	punto.modulate = color
	punto.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
	punto.custom_minimum_size = Vector2(32,32)
	var posicion_restada : Vector3 = posicion_jugador - nodo.global_position
	punto.position = Vector2(posicion_restada.x,posicion_restada.z)
	objetos.append([punto,nodo])

func _process(delta: float) -> void:
	anim_player.speed_scale = 1/radar_velocidad
	for objeto in objetos:
		var punto : TextureRect = objeto[0]
		var nodo : Node3D = objeto[1]
		punto.position = Vector2(nodo.position.x,nodo.position.z)
		punto.position -= Vector2(posicion_jugador.x,posicion_jugador.z)
		punto.position *= zoom
		
		if punto.position.distance_to(punto_jugador.position) > aro.custom_minimum_size.x + offset:
			create_tween().tween_property(punto,"modulate",Color.TRANSPARENT,0.1)
		else:
			create_tween().tween_property(punto,"modulate",Color.RED,0.1)
		
		
		
