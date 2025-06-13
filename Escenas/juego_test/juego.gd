extends Node

var nivel : PackedScene = preload("res://Escenas/nivel_1/Nivel1.tscn")

func _ready() -> void:
	Globals.music_player = $MusicPlayer

func _on_jugar_pressed() -> void:
	$MenuTitulo/AnimationPlayer.play("fade")
	await get_tree().create_timer(3).timeout
	var nivel_sc = nivel.instantiate()
	add_child(nivel_sc)
	Globals.nivel = nivel_sc
	$MenuTitulo.hide()

func _on_opciones_pressed() -> void:
	$MenuTitulo.hide()
	$Settings.show()

func _on_volver_settings_pressed() -> void:
	$Settings.hide()
	$MenuTitulo.show()

func _on_creditos_boton_pressed() -> void:
	$Creditos/FedePlayer.play()
	$MenuTitulo.hide()
	$Creditos.show()

func _on_volver_creditos_pressed() -> void:
	$MenuTitulo.show()
	$Creditos.hide()
