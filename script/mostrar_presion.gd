extends Node2D

var Flechas : Array = []

func _ready():
	var nombres = ["Izquierda.png","Abajo.png","Derecha.png","Arriba.png"]
	for nombre in nombres:
		var tex = load("res://assets/%s" % nombre)
		if tex == null:
			push_error("❌ No se cargó la imagen: " + nombre)
		Flechas.append(tex)


@onready var texture_rects : Array = [
	$HBoxContainer/TextureRect,
	$HBoxContainer/TextureRect2,
	$HBoxContainer/TextureRect3,
	$HBoxContainer/TextureRect4,
	$HBoxContainer/TextureRect5
]

var indice_actual : int = 0

func _on_flecha_presionada(flecha:int):
	print("➡️ Recibida flecha: ", flecha)
	if indice_actual < texture_rects.size():
		texture_rects[indice_actual].texture = Flechas[flecha - 1]
		texture_rects[indice_actual].modulate = Color.WHITE # reset color por defecto
		indice_actual += 1

func _on_limpiar_flechas():
	# limpiar tras feedback
	await get_tree().create_timer(0.5).timeout
	for rect in texture_rects:
		rect.texture = null
		rect.modulate = Color.WHITE
	indice_actual = 0

func _on_correcto():
	print("✅ Llamado correcto (verde)")
	_feedback_color(Color.GREEN)

func _on_incorrecto():
	print("❌ Llamado incorrecto (rojo)")
	_feedback_color(Color.RED)

# -----------------------
# Helpers
# -----------------------

func _feedback_color(color:Color):
	# pintar las flechas usadas con el color indicado
	for i in range(indice_actual):
		texture_rects[i].modulate = color
