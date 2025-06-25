extends Node

var nivel : PackedScene = preload("res://Escenas/Vertical/Vertical.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_viewport().set_input_as_handled()

func _on_jugar_pressed() -> void:
	$MenuTitulo/AnimationPlayer.play("fade")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_packed(nivel)
	$MenuTitulo.hide()

func _on_opciones_pressed() -> void:
	$MenuTitulo.hide()
	$Settings.show()

func _on_volver_settings_pressed() -> void:
	$Settings.hide()
	$MenuTitulo.show()

func _on_creditos_boton_pressed() -> void:
	$MenuTitulo.hide()
	$Creditos.show()

func _on_volver_creditos_pressed() -> void:
	$MenuTitulo.show()
	$Creditos.hide()
