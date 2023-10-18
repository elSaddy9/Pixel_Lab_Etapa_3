extends Area2D

##Atributos onready
onready var colisionador: CollisionShape2D = $CollisionShape2D
onready var animacion: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	controlar_colisionador(true)
	
func controlar_colisionador(esta_desactivado: bool) -> void:
	colisionador.set_deferred("disabled",esta_desactivado)
	
func activar()->void:
	controlar_colisionador(false)
	animacion.play("Activandose")
	
func _on_AnimationPlayer_animation_finished(anim_name: String)->void:
	if anim_name == "Activandose":
		animacion.play("Activado")
