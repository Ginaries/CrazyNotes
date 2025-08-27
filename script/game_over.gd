extends Control


func _on_texture_button_pressed() -> void:
	AudioPlayer.get_node("gameover").stop()
	get_tree().change_scene_to_file("res://scene/menu.tscn")
