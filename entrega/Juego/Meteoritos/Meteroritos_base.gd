class_name Meteorito
extends RigidBody2D

##Atributos export
export var vel_lineal_base:Vector2 = Vector2(300.0,300.0)
export var vel_ang_base:float = 3.0
export var hitpoints_base:float = 10.0
export var modificador_velocidad:Vector2 = Vector2(1.1,1.4)

##Atributos
var hitpoints: float
var esta_en_sector:bool = true setget set_esta_en_sector
var pos_spawn_original:Vector2
var vel_spawn_original:Vector2
var esta_destruido:bool = false

##Metodos
func _ready() -> void:
	angular_velocity = vel_ang_base
	
##Setter y Getters
func set_esta_en_sector(valor:bool) -> void:
	esta_en_sector = valor
	
##Constructor
func crear(pos:Vector2, dir:Vector2, tamanio:float)->void:
	position = pos
	pos_spawn_original = position
	#Calcular Masa, tamaño de Sprite y de Colisionador
	mass *= tamanio
	$Sprite.scale = Vector2.ONE  * tamanio
	#radio = diametro /2
	var radio:int = int ($Sprite.texture.get_size().x / 2.3 * tamanio)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	#Calcular velocidades
	linear_velocity = vel_lineal_base * dir / tamanio * modificador_vel()
	angular_velocity = (vel_ang_base / tamanio) * modificador_vel()
	#Calcular hitpoints
	hitpoints = hitpoints_base * tamanio
## Metodos
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if esta_en_sector:
		return
	
	var mi_transform := state.get_transform()
	mi_transform.origin = pos_spawn_original
	linear_velocity = vel_spawn_original
	state.set_transform(mi_transform)
	esta_en_sector =true

func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	$AnimationPlayer.play("recibir_danio")	
	if hitpoints <= 0.0 and not esta_destruido :
		esta_destruido = true
		destruir()
	$AudioDanio.play()
	
	
func destruir() -> void:
	$CollisionShape2D.set_deferred("desabled", true)
	Eventos.emit_signal("meteorito_destruido", global_position)
	queue_free()

func modificador_vel()-> float:
	randomize()
	return rand_range(modificador_velocidad[0], modificador_velocidad[1])


