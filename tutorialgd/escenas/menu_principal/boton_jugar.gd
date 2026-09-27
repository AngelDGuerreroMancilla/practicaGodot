extends Button

@export var escena_principal: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_jugar, 4)

func _jugar():
	get_tree().change_scene_to_packed(escena_principal)
