##ContenedorInfoEnergia
class_name ContenedorInfoEnergia
extends ContenedorInformacion

##Atributos Onready
onready var medidor:ProgressBar = $ProgressBar

##Metodos Custom
func actualizar_energia(energia_max:float, energia_actual:float)->void:
# warning-ignore:narrowing_conversion
	var energia_porcentual:int = (energia_actual * 100) / energia_max
	medidor.value = energia_porcentual

func _ready() -> void:
	ocultar()
