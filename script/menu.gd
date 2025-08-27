extends Control

@onready var rich_text_label: RichTextLabel = $RichTextLabel

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/test.tscn")
	


func _ready() -> void:
	rich_text_label.bbcode_enabled = true
	rich_text_label.text = "[center][wave amp=25 freq=5][b][color=yellow][outline_size=4][outline_color=black] HIGHSCORE: " + str(Save.highscore) + "[/outline_color][/outline_size][/color][/b][/wave][/center]"
	AudioPlayer.musicafondo()
