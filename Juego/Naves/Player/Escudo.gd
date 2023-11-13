class_name Escudo
extends Area2D

##Atributos export
export var energia:float = 8.0
export var radio_desgaste:float = -1.6
##Atributos onready
onready var colisionador: CollisionShape2D = $CollisionShape2D
onready var animacion: AnimationPlayer = $AnimationPlayer

##Variables
var esta_activado:bool = false setget ,get_esta_activado
var energia_original:float

func _ready() -> void:
	set_process(false)
	controlar_colisionador(true)
	
	
func _process(delta: float) -> void:
	energia += radio_desgaste * delta
	if energia <= 0:
		desactivar()
## Setters y Getters
func get_esta_activado() -> bool:
	return esta_activado
	
func controlar_colisionador(esta_desactivado: bool) -> void:
	colisionador.set_deferred("disabled",esta_desactivado)
##Metdos custom
func activar()->void:
	if energia <= 0.0:
		return
	set_process(true)
	esta_activado = true
	controlar_colisionador(false)
	animacion.play("Activandose")

func desactivar() -> void:
	set_process(false)
	esta_activado = false
	controlar_colisionador(true)
	animacion.play_backwards("Activandose")

func controlar_energia(consumo:float) ->void:
	energia += consumo
	
	if energia > energia_original:
		energia = energia_original
		
	elif energia <= 0.0:	
			desactivar()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Activandose" and esta_activado:
		animacion.play("Activado")
		set_process(true) # Replace with function body.


func _on_body_entered(body: Node) -> void:
	if body is Proyectil:
		body.queue_free() # Replace with function body.
