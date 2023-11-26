class_name EstacionEnemiga
extends Node2D
##Atributos Export
export var hitpoints:float = 30.0
export var orbital:PackedScene = null
export var numero_orbitales:int = 10
export var intervalo_spawn:float = 0.8
##Atributos Onready
onready var impacto_sfx:AudioStreamPlayer2D = $ImpactoSfx
onready var timer_spawner:Timer = $TimerSpawnEnemigos

##Atributos
var esta_destruida:bool = false
var pos_spawn:Vector2 = Vector2.ZERO
##Metodos
func _ready() -> void:
	timer_spawner.wait_time = intervalo_spawn
	$AnimationPlayer.play(elegir_animacion_aleatoria())


##Metodos Custom
func elegir_animacion_aleatoria()->String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() - 1
	var indice_anim_aleatoria:int = randi() % num_anim +1
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	
	return lista_animacion[indice_anim_aleatoria]

func recibir_danio(danio:float)->void:
	hitpoints -= danio
	
	if hitpoints <= 0 and not esta_destruida:
		esta_destruida = true
		destruir()
	impacto_sfx.play()	
	
func spawnaear_orbital()->void:
	numero_orbitales -= 1
	$RutaEnemigo.global_position = global_position
	
	var new_orbital:EnemigoOrbital = orbital.instance()
	new_orbital.crear(
		global_position + pos_spawn,
		self,
		$RutaEnemigo
	)
	Eventos.emit_signal("spawn_orbital",new_orbital) 

func deteccion_cuadrante()->Vector2:
	var player_objetivo:Player = DatosJuego.get_player_actual()
	
	if not player_objetivo:
		return Vector2.ZERO
		
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angulo_player:float = rad2deg(dir_player.angle())
	
	if abs(angulo_player) <= 45.0:
		#Player entra a la derecha
		$RutaEnemigo.rotation_degrees = 180.0
		return $PuntosSpawn/Este.position
	elif abs(angulo_player) >135.0 and abs(angulo_player) <= 180.0:
		#Player entra por la izquierda
		$RutaEnemigo.rotation_degrees = 0.0
		return $PuntosSpawn/Oeste.position
	elif abs(angulo_player) > 45.0 and abs(angulo_player) <= 135.0:
		#Player entra por arriba o por abajo
		if sign(angulo_player) > 0:
			#Player entra por abajo
			$RutaEnemigo.rotation_degrees = 270.0
			return $PuntosSpawn/Sur.position
		else:
			#Player entra por arriba
			$RutaEnemigo.rotation_degrees = 90.0
			return $PuntosSpawn/Norte.position
	
	return $PuntosSpawn/Norte.position

##Señales Internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir() # Replace with function body.

func destruir()->void:
	var posicion_partes = [
		$Sprites/Parte1.global_position,
		$Sprites/Parte2.global_position,
		$Sprites/Parte4.global_position,
		$Sprites/Parte3.global_position
	]
	
	Eventos.emit_signal("base_destruida",self,posicion_partes)
	Eventos.emit_signal("minimapa_objeto_destruido",self)
	queue_free()

func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	pos_spawn = deteccion_cuadrante() # Replace with function body.
	spawnaear_orbital()
	timer_spawner.start()
	# Replace with function body.


func _on_TimerSpawnEnemigos_timeout() -> void:
	if numero_orbitales == 0:
		timer_spawner.stop()
		return
	spawnaear_orbital() # Replace with function body.
