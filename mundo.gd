extends Node2D
#=============================================================================================
# FICHERO: mundo.gd
# PINTA el MUNDO: Rejilla, Ejes de coordenadas
#=============================================================================================

const Cnt = preload("res://constantes.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Pintamos Mundo ...")

func _draw():
	# ========================================================================================
	#	Pinta el MUNDO
	#=========================================================================================
	

	# ========= CUADRÍCULA ===================================================================
	var dim = Cnt.TAMANO_MUNDO_METROS
	var origen= Vector2(-0.5 * dim, -0.5 * dim)	# Origen de la rejilla
	var final = Vector2( 0.5 * dim,  0.5 * dim)		# Final de la rejilla
	var escala = get_viewport().get_camera_2d().zoom.x
	var grosor = 1 + 1/escala				# Z= 0.1 => g=10 : z= 1.0 => g=1
	pinta_cuadricula(
		origen,
		final,
		Cnt.MxC,
		grosor
	)	

	# ========= EJES =========================================================================
	var mitad_mundo_px = 0.5 * Cnt.TAMANO_MUNDO_METROS
	var mitad_mundo_py = 0.5 * Cnt.TAMANO_MUNDO_METROS	
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
		Vector2(0, -mitad_mundo_py),
		Color.GREEN,
		grosor,
		50.0
	)
	# EJE Y NEGATIVO (verde discontinuo)
	draw_dashed_line(
		Vector2(0, 0),
		Vector2(0, mitad_mundo_py),
		Color.GREEN,
		grosor,				#Grosor de la línea
		50.0				#Longitud de los segmentos
	)

#	===== PINTA CRUZ ========================================================================
	pinta_cruz(
		Vector2(20.0*Cnt.PxM,20.0*Cnt.PxM),	# Posición en metros
		1.0,				# Tamaño en metros
		Color.CRIMSON,		# Color
		5					# Grosor en pixeles
	)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# ============================================================================================
#	FUNCIONES AUXILIARES
#=============================================================================================

# ========= PINTA una REJILLA en el SUELO ====================================================
func pinta_cuadricula(
		ini: Vector2,		# (m) Origen de la cuadricula del suelo 
		fin: Vector2,		# (m) Final de la cuadricula del suelo
		paso: float,		# (m) Distancia entre lineas
		grosor: int			# (pixel) grosor de la linea
	) -> void:
	var dist = fin - ini
	if dist.x * paso > 0:
		dist.x = paso * Cnt.PxM
	else:
		dist.x = -paso * Cnt.PxM
	if dist.y * paso > 0:
		dist.y = paso * Cnt.PxM
	else:
		dist.y = -paso * Cnt.PxM
	print("Rejilla: ", " dx:",dist.x, " dy:", dist.y)
	print("          ini.x:",ini.x, " ini.y:",ini.y, " fin.x:",fin.x, " fin.y:",fin.y)
	
	for y in range(ini.y, fin.y, dist.y):
		draw_line(
			Vector2(ini.x, y),
			Vector2(fin.x, y),
			Cnt.GRID_COLOR_G,
			grosor
		)
	for x in range(ini.x, fin.x, dist.x):
		draw_line(
			Vector2(x, ini.x),
			Vector2(x, fin.x),
			Cnt.GRID_COLOR_G,
			grosor
		)
		
# ========= PINTA una CRUZ ===================================================================
func pinta_cruz(
		centro: Vector2,	# metros
		tam: float,			# metros
		color: Color,
		grueso: float		# grosor linea
	) -> void:

	# línea horizontal
	var c = centro
	var t = tam
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
	print("Cruz", c )
	
