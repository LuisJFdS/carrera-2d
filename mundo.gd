extends Node2D
#=============================================================================================
# FICHERO: mundo.gd
#
#=============================================================================================

const Cnt = preload("res://constantes.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Pintamos Mundo ...")
	queue_redraw()

func _draw():
	var grosor = get_viewport().get_camera_2d().zoom.x
	grosor = grosor + 1/grosor
	var mitad_mundo_px = (Cnt.TAMANO_MUNDO_METROS * Cnt.PIXELES_POR_METRO) * 0.5
	var paso_px = Cnt.METROS_POR_CUADRO * Cnt.PIXELES_POR_METRO
	
	# ========================================================================================
	#	Pinta el MUNDO
	#=========================================================================================
	#
	# ========= CUADRÍCULA ===================================================================
	for x in range(-mitad_mundo_px, mitad_mundo_px + paso_px, paso_px):
		draw_line(
			Vector2(x, -mitad_mundo_px),
			Vector2(x,  mitad_mundo_px),
			Cnt.GRID_COLOR_G,
			grosor
		)
	for y in range(-mitad_mundo_px, mitad_mundo_px + paso_px, paso_px):
		draw_line(
			Vector2(-mitad_mundo_px, y),
			Vector2( mitad_mundo_px, y),
			Cnt.GRID_COLOR_R,
			grosor
		)
	
	# ========= EJES =========================================================================
	# EJE X POSITIVO (rojo continuo)
	draw_line(
		Vector2(0, 0),
		Vector2(mitad_mundo_px, 0),
		Color.RED,
		grosor
	)
	# EJE X NEGATIVO (rojo discontinuo)
	draw_dashed_line(
		Vector2(0, 0),
		Vector2(-mitad_mundo_px, 0),
		Color.RED,
		grosor,
		50.0
	)
	# EJE Y POSITIVO (verde continuo)
	draw_line(
		Vector2(0, 0),
		Vector2(0, -mitad_mundo_px),
		Color.GREEN,
		grosor,
		50.0
	)
	# EJE Y NEGATIVO (verde discontinuo)
	draw_dashed_line(
		Vector2(0, 0),
		Vector2(0, mitad_mundo_px),
		Color.GREEN,
		grosor,				#Grosor de la línea
		50.0				#Longitud de los segmentos
	)

#	===== PINTA CRUZ ========================================================================
	pinta_cruz(
		Vector2(15.0,15.0),	# Posición en metros
		1.0,				# Tamaño en metros
		Color.CRIMSON,		# Color
		5					# Grosor en pixeles
	)
	
	# ========================================================================================
	#	FUNCIONES AUXILIARES
	#=========================================================================================
	#
	# ========= PINTA una CRUZ ===============================================================
# Pintar una CRUZ
func pinta_cruz(
		centro: Vector2,	# metros
		tam: float,			# metros
		color: Color,
		grueso: float		# grosor linea
	) -> void:

	# línea horizontal
	var c = centro*50
	var t = tam*50
	c.y = -c.y
	draw_line(
		Vector2(c.x - t, c.y),
		Vector2(c.x + t, c.y),
		color,
		grueso
	)
	# línea vertical
	draw_line(
		Vector2(c.x, c.y - t),
		Vector2(c.x, c.y + t),
		color,
		grueso
	)
	print("Cruz")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
