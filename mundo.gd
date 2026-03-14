extends Node2D
#=============================================================================================
# FICHERO: mundo.gd
# PINTA el MUNDO: Rejilla, Ejes de coordenadas
# Función pinta_cruz
#=============================================================================================

#const Cnt = preload("res://constantes.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globales.flags.flag0 and Globales.flags.flag1 < 2:
		Globales.flags.flag1 += 1
		print("mundo.gd/func _ready() VACIO flag1: ", Globales.flags.flag1)

func _draw():
	if Globales.flags.flag0:
		print("mundo.gd/func _draw() Pinta cuadricula, coordenadas y cruz (12.5,12.5)")
	# ========================================================================================
	#	Pinta el MUNDO
	#=========================================================================================
	
	# ========= PINTA CUADRÍCULA =============================================================
	var dim = Constantes.TAMANO_MUNDO_METROS
	var origen= Vector2(-0.5 * dim, -0.5 * dim)	# Origen de la rejilla
	var final = Vector2( 0.5 * dim,  0.5 * dim)		# Final de la rejilla
	var escala = get_viewport().get_camera_2d().zoom.x
	var grosor = 3/escala				# Z= 0.1 => g=10 : z= 1.0 => g=3
	pinta_cuadricula(
		origen,
		final,
		Constantes.MxC,
		grosor
	)	

	# ========= PINTA EJES ===================================================================
	pinta_eje_coordenadas(
		Vector2(0,0),
		Vector2(0.5 * Constantes.TAMANO_MUNDO_METROS, 0.5 * Constantes.TAMANO_MUNDO_METROS),
		grosor
	)

#	===== PINTA CRUZ ========================================================================
	pinta_cruz(
		Vector2(12.5,12.5),	# Posición en metros
		1.0,				# Tamaño en metros
		Color.CRIMSON,		# Color
		5					# Grosor en pixeles
	)
	if Globales.flags.flag0 and Globales.flags.flag1 < 1:
		print("mundo.gd/func _ready - final flag1", Globales.flags.flag1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globales.flags.flag0 and Globales.flags.flag1 < 2:
		Globales.flags.flag1 += 1
		print("mundo.gd/func _process() - VACIO flag1", Globales.flags.flag1)
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
		dist.x = paso * Constantes.PxM
	else:
		dist.x = -paso * Constantes.PxM
	if dist.y * paso > 0:
		dist.y = paso * Constantes.PxM
	else:
		dist.y = -paso * Constantes.PxM
	
	for y in range(ini.y, fin.y+dist.y, dist.y):
		draw_line(
			Vector2(ini.x, y),
			Vector2(fin.x, y),
			Constantes.GRID_COLOR_G,
			grosor
		)
	for x in range(ini.x, fin.x+dist.x, dist.x):
		draw_line(
			Vector2(x, ini.x),
			Vector2(x, fin.x),
			Constantes.GRID_COLOR_G,
			grosor
		)

# ========= PINTA EJE de COORDENADAS =========================================================
func pinta_eje_coordenadas(
		centro: Vector2,
		long: Vector2,		# (m)
		grosor
	) -> void:
		# EJE X POSITIVO (rojo -> continuo)
	draw_line(
		centro,
		Vector2(centro.x + long.x, centro.x),
		Color.RED,
		grosor
	)
	# EJE X NEGATIVO (rojo -> discontinuo)
	draw_dashed_line(
		centro,
		Vector2(centro.x - long.x, centro.x),
		Color.RED,
		grosor,
		50.0
	)
	# EJE Y POSITIVO (verde -> continuo)
	draw_line(
		centro,
		Vector2(centro.y, centro.y-long.y),
		Color.GREEN,
		grosor,
		50.0
	)
	# EJE Y NEGATIVO (verde -> discontinuo)
	draw_dashed_line(
		centro,
		Vector2(centro.y, centro.y + long.y),
		Color.GREEN,
		grosor,				#Grosor de la línea
		50.0				#Longitud de los segmentos
	)
	
	# ===== Pintar una CRUZ ======================================================================
func pinta_cruz(
		centro: Vector2,
		tam: float,
		color: Color,
		ancho: float = 10.0
	) -> void:
	var c= centro * Constantes.PxM
	var l= tam * Constantes.PxM
		
	# línea horizontal
	draw_line(
		Vector2(c.x - l, -c.y),
		Vector2(c.x + l, -c.y),
		color,
		ancho
	)
	# línea vertical
	draw_line(
		Vector2(c.x, -c.y - l),
		Vector2(c.x, -c.y + l),
		color,
		ancho
	)
	print("mundo.gd/func pinta_cruz() c y l: ", c," ",l)
	
