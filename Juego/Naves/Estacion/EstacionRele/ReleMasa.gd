class_name ReleMasa
extends Node2D

##Atributo Onready
onready var animaciones:AnimationPlayer = $AnimationPlayer

##Metodos Custom
func atraer_player(body:Node)->void:
	$Tween.interpolate_property(
		body,
		"global_position",
		body.global_position,
		global_position,
		1.0,
		Tween.TRANS_CIRC,
		Tween.EASE_IN
	)
	$Tween.start()
##Señales Internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Spawn":
		animaciones.play("Activado") # Replace with function body.

func _on_Area2D_body_entered(body: Node) -> void:
	animaciones.play("Super_Activado")
	$Area2D/CollisionShape2D.set_deferred("disabled",true) # Replace with function body.
	body.desactivar_controles()
	atraer_player(body)


func _on_Tween_tween_all_completed() -> void:
	print("Sos crack, pasaste de nivel!!!") # Replace with function body.
