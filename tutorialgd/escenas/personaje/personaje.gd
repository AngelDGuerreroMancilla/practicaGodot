extends CharacterBody2D

signal personaje_muerto

@export var animacion: AnimatedSprite2D 
@export var area_2D: Area2D 
@export var material_personaje_rojo : ShaderMaterial

@onready var sonido_muerte: AudioStreamPlayer2D = $SonidoMuerte
@onready var sonido_salto: AudioStreamPlayer2D = $SonidoSalto


var _velocidad : float = 100.0
var _velocidad_salto: float = -300.0
var _muerto: bool

# --- Variables Nuevas para el Touchpad ---
var sensibilidad_movimiento: float = 3.0
var sensibilidad_salto: float = 15.0
var tiempo_sin_mover: float = 0.0

# Variables exclusivas para saber si el touchpad está enviando movimiento
var _touchpad_derecha: bool = false
var _touchpad_izquierda: bool = false
var _touchpad_salto: bool = false
# -----------------------------------------

func _ready():
	add_to_group("personajes")
	area_2D.body_entered.connect(_on_area_2d_body_entered)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# --- Nueva función: Leer el Touchpad (deslizamiento) ---
func _input(event: InputEvent) -> void:
	if _muerto: 
		return 

	if event is InputEventMouseMotion:
		tiempo_sin_mover = 0.0 
		
		# Movimiento lateral
		if event.relative.x > sensibilidad_movimiento:
			_touchpad_derecha = true
			_touchpad_izquierda = false
		elif event.relative.x < -sensibilidad_movimiento:
			_touchpad_izquierda = true
			_touchpad_derecha = false
			
		# Salto (hacia arriba)
		if event.relative.y < -sensibilidad_salto:
			_touchpad_salto = true

# --- Detener al personaje (solo la parte del touchpad) ---
func _process(delta: float) -> void:
	if _muerto: return
	
	tiempo_sin_mover += delta
	if tiempo_sin_mover > 0.1:
		_touchpad_derecha = false
		_touchpad_izquierda = false

# --- Movimiento ---
func _physics_process(delta):
	if _muerto:
		return
	
	# gravedad
	velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("saltar") && is_on_floor():
		sonido_salto.play()
		velocity.y += _velocidad_salto
		
	# Salto: Revisa si tocaste el teclado O si deslizaste en el touchpad
	if (Input.is_action_just_pressed("saltar") or _touchpad_salto) and is_on_floor():
		velocity.y += _velocidad_salto
		
	# Limpiamos el salto del touchpad para simular que solo se presionó una vez
	_touchpad_salto = false 
	
	# mov lateral: Revisa si usas el teclado O el touchpad
	if Input.is_action_pressed("derecha") or _touchpad_derecha:
		velocity.x = _velocidad 
		animacion.flip_h = true
	elif Input.is_action_pressed("izquierda") or _touchpad_izquierda:
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
	sonido_muerte.play()
	animacion.material = material_personaje_rojo
	_muerto = true
	
	animacion.stop()
	
	await  get_tree().create_timer(0.5).timeout
	# Liberamos el cursor al morir
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Apagamos el movimiento del touchpad por seguridad
	_touchpad_derecha = false
	_touchpad_izquierda = false
	
	await get_tree().create_timer(0.5).timeout
	
	personaje_muerto.emit()
	ControladorGlobal.sumar_muerte()
