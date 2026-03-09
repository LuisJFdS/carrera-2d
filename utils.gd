extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
