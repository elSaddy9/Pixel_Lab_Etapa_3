class_name Meteorito
extends RigidBody2D

##Atributos export
export var vel_lineal_base:Vector2 = Vector2(300.0,300.0)
export var vel_ang_base:float = 3.0
export var hitpoints_base:float = 10.0
export var modificador_velocidad:Vector2 = Vector2(1.1,1.4)

##Atributos
var hitpoints: float
##Metodos
func _ready() -> void:
	angular_velocity = vel_ang_base
	
##Constructor
func crear(pos:Vector2, dir:Vector2, tamanio:float)->void:
	position = pos
	#Calcular Masa, tamaño de Sprite y de Colisionador
	mass *= tamanio
	$Sprite.scale = Vector2.ONE  * tamanio
	#radio = diametro /2
	var radio:int = int ($Sprite.texture.get_size().x / 2.3 * tamanio)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	#Calcular velocidades
	linear_velocity = (vel_lineal_base * dir / tamanio) * modificador_vel()
	angular_velocity = (vel_ang_base / tamanio) * modificador_vel()
	#Calcular hitpoints
	hitpoints = hitpoints_base * tamanio
	
func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	$AnimationPlayer.play("recibir_danio")	
	if hitpoints <= 0.0 :
		destruir()
	$AudioDanio.play()
	
	
func destruir() -> void:
	$CollisionShape2D.set_deferred("desabled", true)
	Eventos.emit_signal("meteorito_destruido", global_position)
	queue_free()

func modificador_vel()-> float:
	randomize()
	return rand_range(modificador_velocidad[0], modificador_velocidad[1])


