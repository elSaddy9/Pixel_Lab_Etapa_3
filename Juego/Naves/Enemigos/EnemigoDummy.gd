extends Area2D



func _on_EnemigoDummy_body_entered(body: Node) -> void:
	if body is Player:
		body.destruir() # Replace with function body.
