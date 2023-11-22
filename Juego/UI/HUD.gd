#HUD.gd
class_name HUD
extends CanvasLayer

##Atributos Onready
onready var info_zona_recarga:ContenedorInformacion = $InfoZonaRecarga
onready var info_meteoritos:ContenedorInformacion = $InfoMeteoritos

func _ready() -> void:
# warning-ignore:return_value_discarded
	Eventos.connect("nivel_iniciado",self,"fade_out")
# warning-ignore:return_value_discarded
	Eventos.connect("nivel_terminado",self,"fade_in")
# warning-ignore:return_value_discarded
	Eventos.connect("detecto_zona_recarga",self,"_on_detecto_zona_recarga")
# warning-ignore:return_value_discarded
	Eventos.connect("cambio_numero_meteoritos",self,"_on_actualizar_info_meteoritos")
func fade_in()->void:
	$FadeCanvas/AnimationPlayer.play("Fade")
	
func fade_out()->void:
	$FadeCanvas/AnimationPlayer.play_backwards("Fade")

func _on_detecto_zona_recarga(en_zona:bool)->void:
	if en_zona:
		info_zona_recarga.mostrar_suavizado()
	else:
		info_zona_recarga.ocultar_suavizado()
	
##Metodos Custom
func _on_actualizar_info_meteoritos(numero:int)->void:
	info_meteoritos.mostrar_suavizado()
	info_meteoritos.modificar_texto(
		"Meteoritos\n Restantes\n      {cantidad}".format({"cantidad":numero})
	)
	if numero <= 0:
		info_meteoritos.ocultar_suavizado()
