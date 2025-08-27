extends Node2D
signal Correcto
signal Incorrecto
signal FlechaPresionada(flecha:int) # 1=izq, 2=abajo, 3=der, 4=arriba
signal LimpiarFlechas

@onready var sprite_2d: Sprite2D = $Sprite2D

var ICONOS : Array[Texture] = [
	preload("res://assets/1.png"),
	preload("res://assets/2.png"),
	preload("res://assets/3.png"),
	preload("res://assets/4.png"),
	preload("res://assets/5.png")
]

var PATRONES : Array = [
	[2,4],
	[3,2,1,4,3],
	[2,3,4],
	[4,3,2,2,3,2],
	[2,4,1,2,2]
]

var patron_actual : Array = []
var input_actual : Array = []
var tipoactual : int = 0

func _ready() -> void:
	randomize()
	_set_new_patron()

func _process(delta: float) -> void:
	Comprobar()

func Comprobar():
	var input_num = 0
	if Input.is_action_just_pressed("ui_left"):
		input_num = 1
	elif Input.is_action_just_pressed("ui_right"):
		input_num = 3
	elif Input.is_action_just_pressed("ui_up"):
		input_num = 4
	elif Input.is_action_just_pressed("ui_down"):
		input_num = 2

	if input_num != 0:
		input_actual.append(input_num)
		emit_signal("FlechaPresionada", input_num)
		print("Ingresado: ", input_actual)

		var index = input_actual.size() - 1
		if input_actual[index] != patron_actual[index]:
			AudioPlayer.sonidoerror()
			Save.puntos -= 1
			if Save.puntos <= 0:
				Save.puntos = 0
			print("❌ Error! Reiniciar")
			input_actual.clear()
			emit_signal("Incorrecto") # <- ahora se distingue
			emit_signal("LimpiarFlechas")
		elif input_actual.size() == patron_actual.size():
			AudioPlayer.sonidocorrecto()
			Save.puntos += 10
			print("✅ Patrón completado correctamente!")
			input_actual.clear()
			emit_signal("Correcto")
			emit_signal("LimpiarFlechas")
			_animar_cambio()

# --------------------
# Helpers
# --------------------

func _set_new_patron():
	tipoactual = randi_range(0, ICONOS.size() - 1)
	sprite_2d.texture = ICONOS[tipoactual]
	patron_actual = PATRONES[tipoactual]
	print("🎵 Nuevo patrón elegido: ", patron_actual)

func _animar_cambio():
	var tween = create_tween()
	tween.tween_property(sprite_2d, "scale", Vector2(0.5, 0.5), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(sprite_2d, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_callback(Callable(self, "_set_new_patron"))
