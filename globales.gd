extends Node	# Node: globales. Al ser globales necesita un Nodo
#=============================================================================================
# Node: globales
# FICHERO: globales.gd
# Definición de la clase Estado_del_Juego
# Se creara la clase EdJ para contener las variables GLOBALES
#=============================================================================================

class PrintControl:
	var flag0 : int = 1
	var flag1 : int = 0	# mundo.gd/func _ready() =1 inicio =2 final
	var flag3 : int = 0 # salida.gd/func _ready() =1 inicio =2 final
	var flag4 : int = 0 # salida.gd/func _process =1 inicio =2 final
var flags = PrintControl.new()
