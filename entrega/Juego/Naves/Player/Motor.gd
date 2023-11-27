class_name Motor
extends AudioStreamPlayer2D

##Atributos esport
export var tiempoTrancision:float = 0.6
export var volumenApagado:float = -30.0

##Atributos onready
onready var tween_sonido:Tween = $Tween

##Atributos
var volumenOriginal:float

func _ready() -> void:
	volumenOriginal = volume_db
	volume_db = volumenApagado
	
func sonido_on()->void:
	if not playing:
		play()
	efecto_transicion(volume_db,volumenOriginal)

func sonido_off()->void:
	efecto_transicion(volume_db,volumenApagado)
		
func efecto_transicion(desde_vol:float,hasta_vol:float)->void:
# warning-ignore:return_value_discarded
	tween_sonido.interpolate_property(
		self,
		"volume_db",
		desde_vol,
		hasta_vol,
		tiempoTrancision,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
# warning-ignore:return_value_discarded
	tween_sonido.start()
	
