extends Node

func _process(_delta: float) -> void:
	$Score.text = "Score: %s" % $Board/Grid.score
	$BestScore.text = "Best Score: %s" % Global.best_score
	
	
func _on_grid_game_over() -> void:
	if $Board/Grid.score > Global.best_score:
		Global.best_score = $Board/Grid.score
	get_tree().reload_current_scene()
	
