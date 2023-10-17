class_name Nivel
extends Node2D
##Atributo onready
onready var contenedor_proyectiles:Node
##Atributos export
export var explocion:PackedScene = null

##Metodos
func _ready() -> void:
	conectar_seniales()
	crear_contenedores()	

##Metodos Custom	
func conectar_seniales()->void:
	Eventos.connect("disparo",self,"on_disparo")
	Eventos.connect("nave_destruida",self,"_on_nave_destrida")
	
	
func crear_contenedores()->void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)
	
func on_disparo(proyectil:Proyectil)->void:
	contenedor_proyectiles.add_child(proyectil)

func _on_nave_destrida(posicion: Vector2, num_explosiones:int)->void:
	for i in range(num_explosiones):
		var new_explosion:Node2D= explocion.instance()
		new_explosion.global_position = posicion
		add_child(new_explosion)
		yield(get_tree().create_timer(0.6),"timeout")
