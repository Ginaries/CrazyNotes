extends Node
@onready var bg_music: AudioStreamPlayer = $bg_music
@onready var error: AudioStreamPlayer = $error
@onready var correcto: AudioStreamPlayer = $correcto
@onready var gameover: AudioStreamPlayer = $gameover

func musicafondo():
	bg_music.play()
	

func sonidoerror():
	error.play()

func sonidocorrecto():
	correcto.play()
	
func musicafinal():
	gameover.play()
