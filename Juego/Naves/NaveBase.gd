#NaveBase.gd
class_name NaveBase
extends RigidBody2D

##Enums
enum ESTADO {SPAWNEANDO, VIVO,INVENCIBLE, MUERTO}

##Atributos export
export var hitpoints: float = 10.0
export var cantidad_explociones:int = 4

##Atributos onready
onready var canion:Canion = $Canion
onready var colisionador: CollisionShape2D = $CollisionShape2D
##Atributos
var estado_actual:int = ESTADO.SPAWNEANDO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
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
					canion.set_puede_disparar(false)
					Eventos.emit_signal("nave_destruida",self,global_position,cantidad_explociones)
					queue_free()
		  _:
					printerr("Error de estado")
	estado_actual = nuevo_estado
##Metodos

##Señales internas
#func _on_AnimationPlayer_animation_finished(anim_name:String)->void:


func destruir()->void:
	controlador_estados(ESTADO.MUERTO)
	
func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	$AudioDanio.play()
	if hitpoints <= 0.0 :
		destruir()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlador_estados(ESTADO.VIVO) # Replace with function body.


func _on_Player_body_entered(body: Node) -> void:
	if body is Meteorito:
		body.destruir()
		destruir() # Replace with function body.

