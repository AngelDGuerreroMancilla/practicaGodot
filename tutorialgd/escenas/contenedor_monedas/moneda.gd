extends Node2D

@export var area_2d : Area2D

var contenedor_monedas: ContenedorMonedas

func _ready() -> void:
	area_2d.body_entered.connect(_recogida)



func _recogida(_body):
	contenedor_monedas.moneda_recogida()
	queue_free()
