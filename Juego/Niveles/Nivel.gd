class_name Nivel
extends Node2D

##Atributos export
export var explocion:PackedScene = null
export var meteorito:PackedScene = null
export var destrucion_meteorito:PackedScene = null

##Atributo onready
onready var contenedor_proyectiles:Node
onready var contenedor_meteoritos:Node
##Metodos
func _ready() -> void:
	conectar_seniales()
	crear_contenedores()	

##Metodos Custom	
func conectar_seniales()->void:
# warning-ignore:return_value_discarded
	Eventos.connect("disparo",self,"on_disparo")
# warning-ignore:return_value_discarded
	Eventos.connect("nave_destruida",self,"_on_nave_destrida")
# warning-ignore:return_value_discarded
	Eventos.connect("spawn_meteorito", self, "_on_spawn_meteoritos")
# warning-ignore:return_value_discarded
	Eventos.connect("meteorito_destruido",self, "_on_meteorito_destruido")
	
func crear_contenedores()->void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)
	
	contenedor_meteoritos = Node.new()
	contenedor_meteoritos.name = "ContenedorMeteoritos"
	add_child(contenedor_meteoritos)

	
func on_disparo(proyectil:Proyectil)->void:
	contenedor_proyectiles.add_child(proyectil)

func _on_nave_destrida(posicion: Vector2, num_explosiones:int)->void:
# warning-ignore:unused_variable
	for i in range(num_explosiones):
		var new_explosion:Node2D= explocion.instance()
		new_explosion.global_position = posicion
		add_child(new_explosion)
		yield(get_tree().create_timer(0.6),"timeout")

func _on_spawn_meteoritos(pos_spawn:Vector2, dir_meteorito:Vector2, tamanio:float) -> void:
	var new_meteorito:Meteorito = meteorito.instance()
	new_meteorito.crear(
		pos_spawn,
		dir_meteorito,
		tamanio
	)
	contenedor_meteoritos.add_child(new_meteorito)

func _on_meteorito_destruido(posicion:Vector2)->void:
	var new_met_explosion: Node2D = destrucion_meteorito.instance()
	new_met_explosion.global_position = posicion
	add_child(new_met_explosion)
	
