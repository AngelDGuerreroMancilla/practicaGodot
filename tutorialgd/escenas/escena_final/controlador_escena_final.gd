extends Node2D

@onready var sonido_ganaste: AudioStreamPlayer2D = $SonidoGanaste
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sonido_ganaste.play()
