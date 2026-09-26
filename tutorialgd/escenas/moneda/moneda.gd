extends Node2D

@export var area_2d : Area2D

var contenedor_monedas: ContenedorMonedas

func _ready() -> void:
	area_2d.body_entered.connect(_recogida)
	_iniciar_animacion()

func _recogida(_body):
	contenedor_monedas.moneda_recogida()
	queue_free()

func _iniciar_animacion() -> void:
	# Imprimimos un mensaje en la consola para confirmar que se está ejecutando
	print("Animando moneda...") 
	
	var tween: Tween = create_tween()
	tween.set_loops() # Dejarlo vacío significa que se repetirá infinitamente
	
	# as_relative() hace que se mueva 15 píxeles desde donde esté en ese momento
	tween.tween_property(self, "position", Vector2(0, -5), 0.5).as_relative().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2(0, 5), 0.5).as_relative().set_trans(Tween.TRANS_SINE)
