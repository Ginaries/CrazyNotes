extends Node2D
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var label_puntos: RichTextLabel = $label_puntos
const NOTAS = preload("res://scene/notas.tscn")
var nivel: int = 1
var puntos_para_subir: int = 50   # cada 50 puntos sube de nivel
var max_nivel: int = 10
@onready var timer_descuento: Timer = $DESCUENTO

var nota

func _ready() -> void:
	Save.puntos=0
	AgregarNotaUnica()
	_actualizar_puntaje()

func AgregarNotaUnica():
	nota = NOTAS.instantiate()
	add_child(nota)
	nota.position = Vector2(350,250)

	nota.connect("Correcto", Callable(self, "_on_correcto"))
	var mostrar = $Presionado
	nota.connect("FlechaPresionada", Callable(mostrar, "_on_flecha_presionada"))
	nota.connect("LimpiarFlechas", Callable(mostrar, "_on_limpiar_flechas"))
	nota.connect("Correcto", Callable(mostrar, "_on_correcto"))
	nota.connect("Incorrecto",Callable(mostrar,"_on_incorrecto"))

func _on_descuento_timeout() -> void:
	progress_bar.value -= 1
	if progress_bar.value <= 0:
		_game_over()

func _game_over():
	print("💀 Game Over!")
	_save_highscore()
	get_tree().change_scene_to_file("res://scene/game_over.tscn")

func _save_highscore():
	if Save.puntos > Save.highscore:
		Save.highscore = Save.puntos
	Save.save_data()

# ----------------------------
# Puntaje con animación
# ----------------------------
func _on_correcto():
	_actualizar_puntaje()
	_animar_puntaje()
	progress_bar.value += 2
	_verificar_nivel()

func _verificar_nivel():
	var nuevo_nivel = int(Save.puntos / puntos_para_subir) + 1
	if nuevo_nivel > nivel and nuevo_nivel <= max_nivel:
		nivel = nuevo_nivel
		_aumentar_dificultad()

func _aumentar_dificultad():
	# acelera el timer un 10% menos cada nivel
	timer_descuento.wait_time = max(0.2, timer_descuento.wait_time * 0.9)

	# opcional: reducir relleno inicial de progress_bar
	progress_bar.max_value = max(10, progress_bar.max_value - 2)

	print("🔥 Nivel subido a: ", nivel, " | Nueva velocidad: ", timer_descuento.wait_time)


func _actualizar_puntaje():
	label_puntos.bbcode_enabled = true
	label_puntos.text = "[center][b][color=lime]Puntos: " + str(Save.puntos) + "[/color][/b][/center]"

func _animar_puntaje():
	var tween = create_tween()
	# escala de rebote
	tween.tween_property(label_puntos, "scale", Vector2(1.3, 1.3), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_puntos, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	# efecto de color brillante
	tween.parallel().tween_property(label_puntos, "modulate", Color(1,1,0,1), 0.15) # amarillo
	tween.parallel().tween_property(label_puntos, "modulate", Color(1,1,1,1), 0.2) # vuelve a blanco
