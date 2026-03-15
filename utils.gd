extends Node	# Node: globales.  Al ser globales necesita un Nodo
#=============================================================================================
# FICHERO: utils.gd
# PUNTOS del UNIVERSO a PANTALLA y VICEVERSA
#
#=============================================================================================

# ===== Coordenadas UNIVERSO a PANTALLA ======================================================
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
	pp: Vector2,			# (pixel) punto de la pantalla (repecto al vertice sup-izq)
	tp: Vector2,			# (pixel) tamaño de pantalla
	pu: Vector2,			# (m) posición en el universo del centro de la pantalla
	ru: float,				# (rad) rotación de la cámara en el universo
	zm: float,				# (multiplo) zoom
	) -> Vector2:
	print ("Entrada PaU pp, tp, pu ", pp, tp, pu)
	var Vr: Vector2 = pp - tp/2				# posicióm pp respecto al centro de la pantalla.
	var resultado := pu + Vr / Constantes.PxM
	resultado = resultado.rotated(ru)
	resultado = resultado / zm
	return resultado
