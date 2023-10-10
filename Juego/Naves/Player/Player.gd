extends RigidBody2D
class_name Player

##Atributos export
export var potencia_motor:int = 20
export var potencia_rotacion:int = 280

##Atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

##Metodos
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
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
