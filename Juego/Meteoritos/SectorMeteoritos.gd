class_name SectorMeteoritos
extends Node2D

export var cantidad_meteoritos:int = 10
##Señales internas
var spawners:Array 

func _ready() -> void:
	almacenar_spawners()
	
##Metodos custom
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
