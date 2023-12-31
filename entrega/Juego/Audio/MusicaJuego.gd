class_name MusicaGame
extends Node

##Atributos Export
export var tiempo_transicion:float = 4.0
export(float, -50.0, -20.0,5.0) var volumen_apagado = -40.0

##Atributos onready
onready var musica_nivel:AudioStreamPlayer = $MusicaNivel
onready var musica_combate:AudioStreamPlayer = $MusicaCombate
onready var tween_on:Tween = $TweenMusicaOn
onready var tween_off:Tween = $TweenMusicaOff

##Atributos
var vol_original_musica_off:float = 0.0

##Metodos Custom
func transicion_musicas()->void:
	if musica_nivel.playing:
		fade_in(musica_combate)
		fade_out(musica_nivel)
	else: 
		fade_in(musica_nivel)
		fade_out(musica_combate)
		
func fade_in(musica_fade_in: AudioStreamPlayer)->void:
	var volumen_original = musica_fade_in.volume_db
	musica_fade_in.volume_db = volumen_apagado
	musica_fade_in.play()
# warning-ignore:return_value_discarded
	tween_on.interpolate_property(
		musica_fade_in,
		"volume_db",
		volumen_apagado,
		volumen_original,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
# warning-ignore:return_value_discarded
	tween_on.start()
	
func fade_out(musica_fade_out:AudioStreamPlayer)->void:
	vol_original_musica_off = musica_fade_out.volume_db
# warning-ignore:return_value_discarded
	tween_off.interpolate_property(
		musica_fade_out,
		"volume_db",
		musica_fade_out.volume_db,
		volumen_apagado,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
# warning-ignore:return_value_discarded
	tween_off.start()
	
func set_streams(streams_musica:AudioStream, stream_combate:AudioStream)->void:
	musica_nivel.stream = streams_musica
	musica_combate.stream = stream_combate
	
func play_musica_nivel()->void:
	stop_todo()
	musica_nivel.play()
	
func stop_todo()->void:
	for nodo in get_children():
		if nodo is AudioStreamPlayer:
			nodo.stop()


# warning-ignore:unused_argument
func _on_TweenMusicaOff_tween_completed(object: Object, key: NodePath) -> void:
	object.stop()
	object.volume_db = vol_original_musica_off # Replace with function body.
