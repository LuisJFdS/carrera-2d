extends Node2D
#=============================================================================================
#	FICHERO: mundo.gd
#	_ready()
#	VACIO: Puede pintar el árbol de nodos
#	_process()
#	PINTA el MUNDO: Rejilla, Ejes de coordenadas
#	PINTA CRUCES con el botón del mouse
#=============================================================================================

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Pinta el arbol de nodos.
	#print(get_tree().root.get_tree_string_pretty())
	pass
		
class CruzDatos:
	var posicion: Vector2
	var longitud: float = 50.0
	var color_cruz = Color.CRIMSON
	var grosor: float = 3
var cruz1:= CruzDatos.new()

	
# ============================================================================================
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# ================ Activa el pintado las CRUCES del mouse
	if Globales.ms.b1 == 3:
		Globales.ms.b1 = 2
		var posicion: Vector2
		posicion = Globales.ms.pos
		posicion = posicion / Globales.pantalla.zoom.x
		posicion = posicion.rotated(Globales.pantalla.rotation)
		posicion = posicion + Globales.pantalla.position
		posicion.y = -posicion.y
		cruz1.posicion= posicion
		queue_redraw()


	# ================= PROCESA: -ZOOM CÁMARA MANUAL- ========================================
	# Se han creado dos ACCIONES en el MAPA de ENTRADAS
	# "+" -> "zoom+"  y  "-" -> "zoom-"
	var zoom : float= 0.0
	if Input.is_action_pressed("zoom+"):
		zoom = Globales.pantalla.zoom.x * 1.02
	if Input.is_action_pressed("zoom-"):
		zoom = Globales.pantalla.zoom.x / 1.02
	if zoom > 0.0:
		zoom = clamp(zoom, Constantes.ZOOM_MIN, Constantes.ZOOM_MAX)
		Globales.pantalla.zoom = Vector2(zoom, zoom)
		queue_redraw()

	# ========================================================================================
	#	Pinta el MUNDO
	#=========================================================================================
func _draw():
	
	# ========= PINTA CUADRÍCULA =============================================================
	pinta_cuadricula(
		Vector2(-0.5 ,0.5)*Constantes.TAMANO_MUNDO_METROS,
		Vector2(0.5 ,-0.5)*Constantes.TAMANO_MUNDO_METROS,
		Constantes.MxC,
		1 / Globales.pantalla.zoom.x
	)

	# ========= PINTA EJES ===================================================================
	pinta_eje_coordenadas(
		Vector2(0,0),
		Vector2(0.5 ,0.5)*Constantes.TAMANO_MUNDO_METROS,
		1 / Globales.pantalla.zoom.x
	)

	# ===== PINTAR CRUCES CON EL MOUSE ===================================================
	pinta_cruz(
		cruz1.posicion,
		cruz1.longitud,			# (pixel) Tamaño
		cruz1.color_cruz,		# Color
		cruz1.grosor / Globales.pantalla.zoom.x			# Grosor en pixeles
	)
	
# ============================================================================================
#	FUNCIONES AUXILIARES
#=============================================================================================

# ========= PINTA una REJILLA en el SUELO ====================================================
func pinta_cuadricula(
		ini: Vector2,		# (m) Origen de la cuadricula del suelo 
		fin: Vector2,		# (m) Final de la cuadricula del suelo
		paso: float,		# (m) Distancia entre lineas
		grosor: float			# (pixel) grosor de la linea
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
	
	# ===== Pintar una CRUZ en el UNIVERSO ===================================================
func pinta_cruz(
		centro: Vector2,	# (pixel) Posición de la cruz
		largo: float,		# (pixel) Tamaño de la cruz
		color: Color,		# 
		grosor: float		# (pixsel) Grosor de las lineas de la cruz
	) -> void:
	
	# línea horizontal
	draw_line(
		Vector2(centro.x - largo, -centro.y),
		Vector2(centro.x -grosor/2, -centro.y),
		color,
		grosor
	)
	draw_line(
		Vector2(centro.x +grosor/2, -centro.y),
		Vector2(centro.x + largo, -centro.y),
		color,
		grosor
	)
	# línea vertical
	draw_line(
		Vector2(centro.x, -centro.y - largo),
		Vector2(centro.x, -centro.y -grosor/2),
		color,
		grosor
	)
	draw_line(
		Vector2(centro.x, -centro.y +grosor/2),
		Vector2(centro.x, -centro.y + largo),
		color,
		grosor
	)

	
