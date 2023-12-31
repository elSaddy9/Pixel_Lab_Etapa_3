class_name EstacionRecarga
extends Node2D

## Atributos onready
onready var carga_sfx:AudioStreamPlayer = $SonidoRecarga
onready var carga_vacia_sfx:AudioStreamPlayer = $SonidoSinEnergia
onready var barra_energia:ProgressBar = $BarraEnergia

## Atributos export
export var energia:float = 6.0
export var radio_energia_regenerada:float = 0.05

##Atributos
var nave_player:Player = null
var player_en_zona:bool = false

##Metodos
func _ready() -> void:
	barra_energia.max_value = energia
	barra_energia.value = energia

func _unhandled_input(event: InputEvent) -> void:
	if not puede_recargar(event):
		return
		
	controlar_energia()
		
	if event.is_action("Recarga_Escudo"):
		nave_player.get_escudo().controlar_energia(radio_energia_regenerada)
	elif event.is_action("Recarga_laser"):
		nave_player.get_laser().controlar_energia(radio_energia_regenerada)
	
	if event.is_action_released("Recarga_laser"):
		Eventos.emit_signal("ocultar_energia_laser")
	elif event.is_action_released("Recarga_Escudo"):
		Eventos.emit_signal("ocultar_energia_escudo")
	
	
func _on_Estacion_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir() # Replace with function body.

func _on_GravedadEstacion_body_entered(body: Node) -> void:
	if body is Player:
		player_en_zona = true
		nave_player = body # Replace with function body.
		Eventos.emit_signal("detecto_zona_recarga",true)
		
		
func _on_GravedadEstacion_body_exited(body: Node) -> void:
	if body is Player:
		player_en_zona = false
		carga_sfx.stop()
		Eventos.emit_signal("detecto_zona_recarga",false)
		# Replace with function body.

func puede_recargar(event: InputEvent) -> bool:
	var hay_input = event.is_action("Recarga_Escudo") or event.is_action("Recarga_laser")
	if hay_input and player_en_zona and energia > 0.0:
		if !carga_sfx.play():
			carga_sfx.play()
		return true
		
	return false

func controlar_energia()->void:
	energia -= radio_energia_regenerada
	if energia <= 0.0:
		carga_vacia_sfx.play()
	
	barra_energia.value = energia
