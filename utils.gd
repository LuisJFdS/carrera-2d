extends Node	# Node: globales.  Al ser globales necesita un Nodo
#=============================================================================================
# FICHERO: utils.gd
# ROTAR la CÁMARA
#
#=============================================================================================

# ===== ROTAR la CÁMARA respecto a un PUNTO ==================================================
func rotar_pantalla(
		centro_de_rotacion: Vector2,
		rotacion_radianes: float
	) -> void:
	var vector_a_rotar: Vector2 = Globales.pantalla.position - centro_de_rotacion
	var vector_rotado: Vector2 = vector_a_rotar.rotated(rotacion_radianes)
	Globales.pantalla.position = vector_rotado
	Globales.pantalla.rotation += rotacion_radianes
	
