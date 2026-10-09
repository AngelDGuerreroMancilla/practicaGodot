extends Node2D

@export var niveles : Array[PackedScene]
@export var controlador_partida: ControladorPartida

@onready var sonido_siguiente_nivel: AudioStreamPlayer2D = $SonidoSiguienteNivel

var _nivel_actual : int = 1 
var _nivel_instanciado: Node

# NUEVA VARIABLE: Actuará como un candado para evitar que el nivel cargue 3 veces
var _cambiando_nivel: bool = false 

func _ready() -> void:
	if ControladorGlobal.nivel > 1:
		_cargar_nivel()
	else:
		_crear_nivel(_nivel_actual)

func _crear_nivel(numero_nivel: int):
	# Cuando el nivel termina de crearse, quitamos el candado
	_cambiando_nivel = false 
	
	_nivel_instanciado = niveles[numero_nivel - 1].instantiate()
	add_child(_nivel_instanciado)
	
	var hijos := _nivel_instanciado.get_children()
	for i in hijos.size(): 
		if hijos[i].is_in_group("personajes"):
			hijos[i].personaje_muerto.connect(_reiniciar_nivel)
			break
			
	ControladorGlobal.nivel = numero_nivel
	controlador_partida.guardar_partida()

func _eliminar_nivel():
	_nivel_instanciado.queue_free()
	
func _reiniciar_nivel():
	# Si ya estamos cambiando de nivel, ignoramos cualquier otra muerte accidental
	if _cambiando_nivel == true:
		return 
		
	_cambiando_nivel = true # Ponemos el candado
	_eliminar_nivel()
	_crear_nivel.call_deferred(_nivel_actual)

func siguiente_nivel():
	# Si ya ganamos, ignoramos si la meta se toca dos veces
	if _cambiando_nivel == true:
		return
		
	_cambiando_nivel = true # Ponemos el candado
	_nivel_actual += 1
	_eliminar_nivel()
	_crear_nivel.call_deferred(_nivel_actual)
	sonido_siguiente_nivel.play()

func _cargar_nivel(): 
	_nivel_actual = ControladorGlobal.nivel
	_crear_nivel.call_deferred(_nivel_actual)
