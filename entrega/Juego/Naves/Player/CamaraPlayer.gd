class_name CamaraPlayer
extends Camera2D

##Variables export
export var variacion_zoom: = 0.5
export var tiempo_transicion:float

## Metodos
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Zoom"):
		controlar_zoom(+variacion_zoom)
	elif event.is_action_released("Zoom"):
		controlar_zoom(-variacion_zoom)
## Metodos custom
func controlar_zoom(mod_zoom: float) -> void:
	zoom.x += mod_zoom
	zoom.y += mod_zoom
