class_name Proyectil
extends Area2D

##Atributos
var velocidad: Vector2 = Vector2.ZERO
var danio:float

##Metodos
func _process(delta: float) -> void:
	position += velocidad * delta

func crear(pos:Vector2, dir:float, vel:float, danio_p:int) -> void:
	position = pos
	rotation = dir
	velocidad = Vector2(vel,0).rotated(dir)




func _on_Proyectil_principal_body_exited(body: Node) -> void:
	queue_free() # Replace with function body.
