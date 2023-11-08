class_name SectorMeteoritos
extends Node2D

export var cantidad_meteoritos:int = 10
export var intervalo_spawn:float = 1.2
##Señales internas
var spawners:Array 
##Metodos
func _ready() -> void:
	$SpawnerTimer.wait_time = intervalo_spawn
	almacenar_spawners()
	conectar_seniales_detectores()

##Constructor
func crear(pos: Vector2, meteoritos:int) -> void:
	global_position = pos
	cantidad_meteoritos = meteoritos
	
##Metodos custom
func conectar_seniales_detectores()-> void:
	for detector in $MeteoritoSpawn.get_children():
		detector.connect("body_entered",self,
		"_on_MeteoritoSpawn_body_entered")
	
func almacenar_spawners()-> void:
	for spawner in $Spawners.get_children():
			spawners.append(spawner)
		
func spawner_aleatorio()-> int:
	randomize()
	return randi()% spawners.size()
	
func _on_SpawnerTimer_timeout() -> void:
	if cantidad_meteoritos == 0:
		$SpawnerTimer.stop()
		return # Replace with function body.
		
	spawners[spawner_aleatorio()].spawnear_meteorito()
	cantidad_meteoritos -= 1

func _on_MeteoritoSpawn_body_entered(body:Node) -> void:
	body.set_esta_en_sector(false)

