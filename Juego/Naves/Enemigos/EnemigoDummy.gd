extends Node2D

##Atributos export
export var hitpoints:float = 10.0

func _process(_delta: float) -> void:
	$Canion.esta_disparando = true

func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0 :
		queue_free()
