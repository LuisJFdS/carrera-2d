extends Object
#=============================================================================================
# FICHERO: utils.gd
# PUNTOS del UNIVERSO a PANTALLA y VICEVERSA
#
#=============================================================================================
#const Cnt = preload("res://constantes.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("utils.gd:  func _ready print No hace nada")
	pass # Replace with function body.

#========================================================================================
# Funcuón para trasladar los puntos del UNIVERSO a la PANTALLA (Sin verificar)
#========================================================================================
func universo_a_pantalla(
		vectorCamara: Vector2,
		rotacionCamara: float,	#Radianes
		zoom: float,
		viewport_size: Vector2
	) -> Vector2:

	# Centro de la pantalla
	var centroPantalla: Vector2 = viewport_size * 0.5

	# Posición relativa a la cámara
	var relativo: Vector2 = -vectorCamara

	# Aplicar rotación inversa de la cámara
	relativo = relativo.rotated(-rotacionCamara)	# Radianes

	# Aplicar zoom
	relativo *= zoom

	# Trasladar al sistema de pantalla
	return centroPantalla + relativo

# ===== Coordenadas PANTALLA a UNIVERSO ======================================================
func pantalla_a_universo(
	pp: Vector2,			# punto de la pantalla (repecto al vertice sup-izq)
	cp: Vector2,			# centro de pantalla (repecto al vertice sup-izq)
	pu: Vector2,			# posición en el universo de la pantalla
	ru: float,				# rotación de la cámara en radianes
	zm: float,				# zoom
	) -> Vector2:
	var Vr: Vector2 = pp-cp				# posicióm pp respecto al centro de la pantalla.
	var resultado := pu + Vr / Constantes.PxM
	resultado = resultado.rotated(ru)
	resultado = resultado / zm
	return resultado

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("utils.gd  :_process")
	pass
