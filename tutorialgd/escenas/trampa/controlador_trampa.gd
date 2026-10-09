extends RigidBody2D

@export var raycast : RayCast2D
# Obtenemos la referencia al nodo de audio que ya creaste
@onready var sonido_trampa: AudioStreamPlayer2D = $SonidoTrampa

func _physics_process(_delta: float) -> void:
	# Verificamos que la trampa ESTÉ congelada Y el raycast detecte algo
	if freeze and raycast.get_collider() != null:
		# 1. Descongelamos la trampa para que caiga
		freeze = false
		
		# 2. Reproducimos el sonido de desprendimiento
		sonido_trampa.play()
