extends CharacterBody2D

@export var animacion: AnimatedSprite2D 


var _velocidad : float = 100.0
var _velocidad_salto: float = -300.0



func _physics_process(delta):
	
	
	# gravedad
	velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") && is_on_floor():
		velocity.y += _velocidad_salto
	
	# mov lateral
	if Input.is_action_pressed("ui_right"):
		velocity.x = _velocidad 
		animacion.flip_h = true
	elif Input.is_action_pressed("ui_left"):
		velocity.x = - _velocidad
		animacion.flip_h =false
	else: 
		velocity.x =0
	move_and_slide()

# animacion
	if !is_on_floor():
		animacion.play("saltar")
	elif velocity.x != 0:
		animacion.play("correr")
	else: 
		animacion.play("idle")
