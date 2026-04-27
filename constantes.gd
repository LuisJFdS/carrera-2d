extends Node	# Node: globales.  Al ser globales necesita un Nodo
#=============================================================================================
# Node: globales
# FICHERO: constantes.gd
# PARAMETROS del PROGRAMA
# Incluir: const Cnt = preload("res://constantes.gd") cuando se necesiten
#=============================================================================================

const VECTOR_CAMARA:= Vector2(0,-20)		# (m)
const ROTACION_CAMARA:= PI

const PxM:= int(50)							# (p/m) PIXELES por METRO
const MxC:= float(5.0)						# (m) METROS x CUADRADO de la REJILLA
const TAMANO_MUNDO_METROS:= float(5000.0)	# (m) 5 km
const GRID_COLOR:= Color(1, 1, 1, 0.08)
const GRID_COLOR_R:= Color(1, 0, 0, 0.15)
const GRID_COLOR_G:= Color(0, 1, 0, 0.1)
const GRID_COLOR_B:= Color(0, 0, 1, 0.1)
const ZOOM_MIN:= float(0.1)
const ZOOM_MAX:= float(1.0)
