class_name Nivel
extends Node2D

##Atributos export
export var explocion:PackedScene = null
export var meteorito:PackedScene = null
export var destrucion_meteorito:PackedScene = null
export var sector_meteoritos:PackedScene = null
export var tiempo_transicion_camara:float = 0.5
export var meteorito_totales:int = 0
export var enemigo_interceptor:PackedScene = null


##Atributo onready
onready var contenedor_proyectiles:Node
onready var contenedor_meteoritos:Node
onready var contenedor_sector_meteoritos:Node
onready var camara_nivel:Camera2D = $CameraNivel
onready var camara_player:Camera2D = $Player/CamaraPlayer
onready var contenedor_enemigos: Node

##Atributos
var player:Player = null

##Metodos
func _ready() -> void:
	conectar_seniales()
	crear_contenedores()	
	player = DatosJuego.get_player_actual()

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
# warning-ignore:return_value_discarded
	Eventos.connect("base_destruida",self, "_on_base_destruida")
	
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
	
	contenedor_enemigos = Node.new()
	contenedor_enemigos.name = "ContenedorEnemigos"
	add_child(contenedor_enemigos)
	
	

func crear_posicion_aleatoria(rango_horizontal:float,
rango_vertical:float)->Vector2:
	randomize()
	var rand_x = rand_range(-rango_horizontal, rango_horizontal)
	var rand_y =rand_range(-rango_vertical, rango_vertical)
	
	return Vector2(rand_x, rand_y)
	
##Conexión señales internas
func on_disparo(proyectil:Proyectil)->void:
	contenedor_proyectiles.add_child(proyectil)

func _on_nave_destrida(nave:Player, posicion: Vector2, num_explosiones:int)->void:
# warning-ignore:unused_variable
	if nave is Player:
		transicion_camaras(
			posicion,
			posicion + crear_posicion_aleatoria(-200.0,200.0),
			camara_nivel,
			tiempo_transicion_camara
		)

	crear_explosion(posicion, num_explosiones, 0.6, Vector2(100.0, 50.0))
		
func _on_base_destruida(pos_partes:Array)->void:
	for posicion in pos_partes:
		crear_explosion(posicion)
		yield(get_tree().create_timer(0.5),"timeout")

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
		crear_sector_enemigos(num_peligros)


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

func crear_sector_enemigos(num_enemigos:int)->void:
# warning-ignore:unused_variable
	for i in range(num_enemigos):
		var new_interceptor:EnemigoInterceptor = enemigo_interceptor.instance()
		var spawn_pos:Vector2 = crear_posicion_aleatoria(1000.0, 800.0)
		new_interceptor.global_position = player.global_position + spawn_pos
		contenedor_enemigos.add_child(new_interceptor)


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

func crear_explosion(
	posicion:Vector2,
	numero:int =1,
	intervalo:float = 0.0,
	rangos_aleatorios:Vector2 = Vector2(0.0,0.0)
)->void:
# warning-ignore:unused_variable
	for i in range(numero):
		var new_explosion:Node2D = explocion.instance()
		new_explosion.global_position = posicion + crear_posicion_aleatoria(
			rangos_aleatorios.x,
			rangos_aleatorios.y
		)
		add_child(new_explosion)
		yield(get_tree().create_timer(intervalo),"timeout")
