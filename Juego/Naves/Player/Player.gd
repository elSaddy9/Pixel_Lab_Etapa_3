class_name Player
extends RigidBody2D


##Atributos export
export var potencia_motor:int = 20
export var potencia_rotacion:int = 100
export var estela_maxima:int = 150

##Atributos onready
onready var canion:Canion = $Canion
onready var laser:RayoLaser = $LaserBeam2D
onready var estela:Estela = $EstelaPocision/Trail2D
onready var motor_sfx:Motor = $Motor

##Atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

##Metodos
func _unhandled_input(event: InputEvent) -> void:
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
