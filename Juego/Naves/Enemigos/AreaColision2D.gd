extends Area2D

export var hitpoints:float = 10.0


func _on_Colisionador_danio_body_entered(body: Node) -> void:
	if body is Player:
		body.destruir()# Replace with function body.


func recibir_danio(danio: float) -> void:
	owner.recibir_danio(danio)
