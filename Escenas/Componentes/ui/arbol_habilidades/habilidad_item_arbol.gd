@tool
extends Panel
class_name HabilidadItemArbol

var seleccionable : bool = false:
	set(value):
			seleccionable = value
			if seleccionable: modulate = Color.WHITE
			else: modulate = Color(1,1,1,0.5)

@export var icono : Texture:
	set(value):
		icono = value
		$VBoxContainer/TextureRect.texture = icono
		
@export var nombre : String:
	set(value):
		nombre = value
		$VBoxContainer/Label.text = nombre
		
@export var descripcion : String :
	set(value):
		descripcion = value
		$Button.tooltip_text = value
		
@export var desbloqueado : bool = false:
	set(value):
		desbloqueado = value
		if desbloqueado: $VBoxContainer/Label.modulate = Color.GREEN
		else: $VBoxContainer/Label.modulate = Color.WHITE
		for habilidad in habilidades_que_desbloquea:
			if desbloqueado: habilidad.seleccionable = true
			else: habilidad.seleccionable = false
		if get_parent() is HBoxContainer: get_parent().get_parent().update()

@export var habilidades_que_desbloquea : Array[HabilidadItemArbol] :
	set(value):
		habilidades_que_desbloquea = value
		dibujar_lineas()
		get_parent().get_parent().update()

func dibujar_lineas():
	for child in get_children(): if child is Line2D: child.queue_free()
	for habilidad in habilidades_que_desbloquea:
		if habilidad:
			var linea : Line2D = Line2D.new()
			add_child(linea)
			
			linea.width = 4
			if habilidad.desbloqueado: linea.default_color = Color.GREEN
			else: linea.default_color = Color.RED
			
			linea.show_behind_parent = true
			linea.position += custom_minimum_size/2
			linea.add_point(Vector2(0,0))
			linea.add_point(global_position.direction_to(habilidad.global_position)*global_position.distance_to(habilidad.global_position))

func _ready() -> void:
	await get_tree().process_frame
	dibujar_lineas()
	if seleccionable: modulate = Color.WHITE
	else: modulate = Color(1,1,1,0.5)


func _on_button_pressed() -> void:
	if seleccionable: desbloqueado = true
