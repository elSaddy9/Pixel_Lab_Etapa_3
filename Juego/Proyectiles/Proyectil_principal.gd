class_name Proyectil
extends Area2D

##Atributos
var velocidad: Vector2 = Vector2.ZERO
var danio:float = 1.0

##Metodos
func _process(delta: float) -> void:
	position += velocidad * delta

func crear(pos:Vector2, dir:float, vel:float, danio_p:int) -> void:
	position = pos
	rotation = dir
	velocidad = Vector2(vel,0).rotated(dir)


func _on_Proyectil_principal_body_exited(body: Node) -> void:
	queue_free() # Replace with function body.

##Señales internas
func _on_VisibilityNotifier2D_screen_exited()-> void:
	queue_free()


func hacer_danio(colision:CollisionObject2D) -> void:
	if colision.has_method("recibir_danio"):
		colision.recibir_danio(danio)
		
	queue_free()
	


func _on_Proyectil_principal_body_entered(body: Node) -> void:
	hacer_danio(body) # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	hacer_danio(area) # Replace with function body.
