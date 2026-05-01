extends Node

var global_volume := 1.0
var audio_players : Array[AudioStreamPlayer] = []

func register_player(p: AudioStreamPlayer):
	audio_players.append(p)
	p.volume_db = linear_to_db(global_volume)


func set_global_volume(v: float) -> void:
	global_volume = v
	for p in audio_players:
		p.volume_db = linear_to_db(global_volume)


func free_players() -> void:
	audio_players = []
