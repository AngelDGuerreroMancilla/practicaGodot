extends CharacterBody2D

signal personaje_muerto

@export var animacion: AnimatedSprite2D 
@export var area_2D: Area2D 
@export var material_personaje_rojo : ShaderMaterial

var _velocidad : float = 100.0
var _velocidad_salto: float = -300.0
var _muerto: bool

# --- Variables Nuevas para el Touchpad ---
var sensibilidad_movimiento: float = 3.0
var sensibilidad_salto: float = 15.0
var tiempo_sin_mover: float = 0.0
# -----------------------------------------

func _ready():
	add_to_group("personajes")
	area_2D.body_entered.connect(_on_area_2d_body_entered)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# --- Nueva función: Leer el Touchpad (deslizamiento) ---
func _input(event: InputEvent) -> void:
	if _muerto: 
		return # Si está muerto, ignoramos el pad

	if event is InputEventMouseMotion:
		tiempo_sin_mover = 0.0 # Reiniciamos porque el dedo se mueve
		
		# Movimiento lateral
		if event.relative.x > sensibilidad_movimiento:
			Input.action_press("derecha")
			Input.action_release("izquierda")
		elif event.relative.x < -sensibilidad_movimiento:
			Input.action_press("izquierda")
			Input.action_release("derecha")
			
		# Salto (hacia arriba)
		if event.relative.y < -sensibilidad_salto:
			Input.action_press("saltar")
			# Liberamos rápido para que el 'is_action_just_pressed' vuelva a funcionar luego
			await get_tree().create_timer(0.05).timeout
			Input.action_release("saltar")

# --- Nueva función: Detener al personaje si el dedo se queda quieto ---
func _process(delta: float) -> void:
	if _muerto: return
	
	tiempo_sin_mover += delta
	if tiempo_sin_mover > 0.1:
		Input.action_release("derecha")
		Input.action_release("izquierda")

# --- Tu código original de movimiento (Intacto) ---
func _physics_process(delta):
	if _muerto:
		return
	
	# gravedad
	velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("saltar") && is_on_floor():
		velocity.y += _velocidad_salto
	
	# mov lateral
	if Input.is_action_pressed("derecha"):
		velocity.x = _velocidad 
		animacion.flip_h = true
	elif Input.is_action_pressed("izquierda"):
		velocity.x = - _velocidad
		animacion.flip_h = false
	else: 
		velocity.x = 0
	move_and_slide()

	# animacion
	if !is_on_floor():
		animacion.play("saltar")
	elif velocity.x != 0:
		animacion.play("correr")
	else: 
		animacion.play("idle")


func _on_area_2d_body_entered(_body: Node2D) -> void:
	animacion.material = material_personaje_rojo
	_muerto = true
	animacion.stop()
	
	# Soltamos los botones virtuales por si te moriste mientras deslizabas el dedo
	Input.action_release("derecha")
	Input.action_release("izquierda")
	
	await get_tree().create_timer(0.5).timeout
	
	personaje_muerto.emit()
	ControladorGlobal.sumar_muerte()
