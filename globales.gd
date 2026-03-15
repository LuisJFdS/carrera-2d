extends Node	# Node: globales. Al ser globales necesita un Nodo
#=============================================================================================
# Node: globales
# FICHERO: globales.gd
# Definición de la clase Estado_del_Juego
# Se creara la clase EdJ para contener las variables GLOBALES
#=============================================================================================

class CamaraDatos:
	var pos_U : Vector2 = Vector2.ZERO			# Posición PUNTO universo
	var pos_P : Vector2 = Vector2.ZERO			# Posición PANTALLA
	var rot_U : float = 0.0						# Rotación UNIVERSO
	var zoom : float = 0.2						# Zoom
	var size_P : Vector2 = Vector2.ZERO			# TAMAÑO de PANTALLA
var cam := CamaraDatos.new()

class MouseDatos:
	var pos : Vector2 = Vector2.ZERO
	var b1 : int = 0
	var b2 : int = 0
	var b3 : int = 0
	var b45 : int =0
var ms := MouseDatos.new()

class PrintControl:
	var flag0 : int = 1
	var flag1 : int = 0 # salida.gd/func _ready() =1 inicio =2 final
	var flag2 : int = 0 # salida.gd/func _process =1 inicio =2 final
	var flag3 : int = 0	# mundo.gd/func _ready() =1 inicio =2 final
	var flag4 : int = 0	# mundo.gd/func _process() =1 inicio =2 final	
	
var flags = PrintControl.new()
