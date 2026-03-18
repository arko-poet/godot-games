class_name Card
extends PanelContainer

signal card_entered(card: Card)
signal card_exited(card: Card)


func _on_mouse_entered() -> void:
	emit_signal("card_entered", self)


func _on_mouse_exited() -> void:
	emit_signal("card_exited", self)
