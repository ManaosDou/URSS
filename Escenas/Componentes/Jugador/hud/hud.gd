extends Control

var municion : int = 0
var max_municion : int = 0

@export var municion_label : Label
@export var max_municion_label : Label

func _process(delta: float) -> void:
	municion_label.text = str(municion)
	max_municion_label.text = str(max_municion)
