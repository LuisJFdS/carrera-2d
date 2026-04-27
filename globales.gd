extends Node	# Node: globales. Al ser globales necesita un Nodo
#=============================================================================================
# Node: globales
# FICHERO: globales.gd
# Definición de la clase Estado_del_Juego
# Se creara la clase EdJ para contener las variables GLOBALES
#=============================================================================================
var crono_mundo: float = 0.0
var pantalla: Camera2D

var nuevo_zoom: float = 0.0
var node_coche: Node2D

class MouseDatos:
	var mov: int = 0
	var pos: Vector2 = Vector2.ZERO
	var rel: Vector2 = Vector2.ZERO
	var vel: Vector2 = Vector2.ZERO
	var rot: int = 0
	var b1: int = 0
	var b2: int = 0
	var b3: int = 0
	var b45 : int = 0
var ms: = MouseDatos.new()


class CruzDatos:
	var posicion: Vector2			# (m)
	var longitud: float = 40.0		# (pixel)
	var color_cruz = Color.CRIMSON
	var grosor: float = 1			# (pixel)
	var activa: bool = false
	
	
