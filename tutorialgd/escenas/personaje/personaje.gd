extends CharacterBody2D

var _velocidad : float = 100.0



func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = _velocidad 
	elif Input.is_action_pressed("ui_left"):
		velocity.x = - _velocidad
	else: 
		velocity.x =0
	move_and_slide()
