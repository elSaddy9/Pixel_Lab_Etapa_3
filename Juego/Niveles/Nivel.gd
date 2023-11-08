class_name Nivel
extends Node2D

##Atributos export
export var explocion:PackedScene = null
export var meteorito:PackedScene = null
export var destrucion_meteorito:PackedScene = null
export var sector_meteoritos:PackedScene = null
export var tiempo_transicion_camara:float = 0.5
export var meteorito_totales:int = 0

##Atributo onready
onready var contenedor_proyectiles:Node
onready var contenedor_meteoritos:Node
onready var contenedor_sector_meteoritos:Node
onready var camara_nivel:Camera2D = $CameraNivel
onready var camara_player:Camera2D = $Player/CamaraPlayer
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
# warning-ignore:return_value_discarded
	Eventos.connect("nave_en_sector_peligro",self,"_on_nave_en_sector_peligro")
	
func crear_contenedores()->void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)
	
	contenedor_meteoritos = Node.new()
	contenedor_meteoritos.name = "ContenedorMeteoritos"
	add_child(contenedor_meteoritos)
	
	contenedor_sector_meteoritos = Node.new()
	contenedor_sector_meteoritos.name = "ContenedorMeteoritos"
	add_child(contenedor_sector_meteoritos)

	
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
	
	controlar_meteoritos_restantes()
	
func _on_nave_en_sector_peligro(centro_cam:Vector2, tipo_peligro:String,
num_peligros:int) -> void:
	if tipo_peligro == "Meteorito":
		crear_sector_meteoritos(centro_cam,num_peligros)
	
	elif tipo_peligro == "Enemigo":
		pass

# warning-ignore:unused_argument
func crear_sector_meteoritos(centro_camara:Vector2, numero_peligros:int) -> void:
	meteorito_totales = numero_peligros
	var new_sector_meteoritos:SectorMeteoritos = sector_meteoritos.instance()
	new_sector_meteoritos.crear(centro_camara, numero_peligros)
	camara_nivel.global_position = centro_camara
	contenedor_sector_meteoritos.add_child(new_sector_meteoritos)
	transicion_camaras(camara_player.global_position,
	camara_nivel.global_position,camara_nivel,
	tiempo_transicion_camara
	)
	print(meteorito_totales)

# warning-ignore:shadowed_variable
func transicion_camaras(desde: Vector2, hasta: Vector2,
camara_actual:Camera2D, tiempo_transicion_camara:float)-> void:
	$TweenCamara.interpolate_property(
		 camara_actual,
		"global_position",
		 desde,
		 hasta,
		 tiempo_transicion_camara,
		 Tween.TRANS_LINEAR,
		 Tween.EASE_IN_OUT
	)
	camara_actual.current = true
	$TweenCamara.start()	

func controlar_meteoritos_restantes() -> void:
	meteorito_totales -=1
	if meteorito_totales == 0 :
		contenedor_sector_meteoritos.get_child(0).queue_free()
		transicion_camaras(
			camara_nivel.global_position,
			camara_player.global_position,
			camara_player,
			tiempo_transicion_camara * 0.10
		)


# warning-ignore:unused_argument
func _on_TweenCamara_tween_completed(object: Object, key: NodePath) -> void:
	if object.name == "CamaraPlayer":
		object.global_position = $Player.global_position # Replace with function body.
