class_name Player
extends RigidBody2D

##Enums
enum ESTADO {SPAWNEANDO, VIVO,INVENCIBLE, MUERTO}

##Atributos export
export var potencia_motor:int = 20
export var potencia_rotacion:int = 100
export var estela_maxima:int = 150
export var puede_pulsar:bool = true
export var hitpoints: float = 10.0


##Atributos onready
onready var canion:Canion = $Canion
onready var laser:RayoLaser = $LaserBeam2D
onready var estela:Estela = $EstelaPocision/Trail2D
onready var motor_sfx:Motor = $Motor
onready var colisionador: CollisionShape2D = $CollisionShape2D
onready var animacion:AnimationPlayer = $AnimationPlayer
##Atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0
var estado_actual:int = ESTADO.SPAWNEANDO



# Called when the node enters the scene tree for the first time.
func _ready():
	_on_AnimationPlayer_animation_finished("spawn")
##Metodos custom
func controlador_estados(nuevo_estado:int)->void:
	match nuevo_estado:
		  ESTADO.SPAWNEANDO:
					colisionador.set_deferred("disabled",true)
					canion.set_puede_disparar(false)
		  ESTADO.VIVO:
					colisionador.set_deferred("disabled",false)
					canion.set_puede_disparar(true)
		  ESTADO.INVENCIBLE:
					colisionador.set_deferred("disabled",true)
		  ESTADO.MUERTO:
					colisionador.set_deferred("disabled",true)
					canion.set_puede_disparar(true)
					Eventos.emit_signal("nave_destruida",global_position,4)
					queue_free()
		  _:
					printerr("Error de estado")
	estado_actual = nuevo_estado
##Metodos
func _unhandled_input(event: InputEvent) -> void:
	if not esta_input_activo():
		return
	
	if 	Input.is_action_just_pressed("Laser"):
		laser.set_is_casting(true)
		
	if Input.is_action_just_released("Laser"):
		laser.set_is_casting(false)
	
	#Control estela	y sonido de motor
	if event.is_action_pressed("Adelante"):
		estela.set_max_points(estela_maxima)
		motor_sfx.sonido_on()
	elif event.is_action_pressed("Atras"):
		estela.set_max_points(0)
		motor_sfx.sonido_on()
	if (event.is_action_released("Adelante") or event.is_action_released("Atras")):
		motor_sfx.sonido_off()
		
func _integrate_forces(_state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	
func _process(delta: float) -> void:
	player_input()
		
func player_input():
		if not esta_input_activo():
			return
		#Empuje
		empuje = Vector2.ZERO
		if Input.is_action_pressed("Adelante"):
			empuje = Vector2(potencia_motor,0)
		elif Input.is_action_pressed("Atras"):
			empuje = Vector2(-potencia_motor,0)
			
		#Rotacion
		dir_rotacion= 0
		if Input.is_action_pressed("Horario"):
			dir_rotacion +=1
		elif Input.is_action_pressed("Antihorario"):
			dir_rotacion-=1
			
		#Disparo
		if Input.is_action_pressed("disparo_principal"):
			canion.set_esta_disparando(true)
			
		if Input.is_action_just_released("disparo_principal"):
			canion.set_esta_disparando(false)
		
func esta_input_activo()->bool:
	if estado_actual in [ESTADO.SPAWNEANDO,ESTADO.MUERTO]:
		return false
	return true

##Señales internas
func _on_AnimationPlayer_animation_finished(anim_name:String)->void:
	if anim_name == "spawn":
		controlador_estados(ESTADO.VIVO)

func destruir()->void:
	controlador_estados(ESTADO.MUERTO)
	
func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	$AudioStreamPlayer.play()
	if hitpoints <= 0.0 :
		destruir()
