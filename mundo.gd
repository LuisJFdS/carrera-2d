extends Node2D
#=============================================================================================
#	FICHERO: mundo.gd
#	_ready()
#	VACIO: Puede pintar el árbol de nodos
#	_process()
#	PINTA el MUNDO: Rejilla, Ejes de coordenadas
#	PINTA CRUCES con el botón del mouse
#=============================================================================================
@onready var coche: Node2D = get_parent().get_node("Coche")			# Permite utilizae las funciones de coche.gd
var st_mundo: int= 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	st_mundo = 0
	pass

var cruz_zona:= Globales.CruzDatos.new()		# ZONA donde puede llegar el coche
var cruz_dest:= Globales.CruzDatos.new()			# ACTIVA el movimiento del coche

# ============================================================================================
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Globales.crono_mundo += delta
	match st_mundo:
		0:
			cruz_zona.activa = true			# .. Activa la cruz imagen para la ZONA de llegada.
			queue_redraw()
			st_mundo = 1
			print ("st_mundo 0 -> 1 Activado cruz_zona: zona llegada")
			
		1:	#.....ESPERANDO CLIC DESTINO
			# ================ b1 == 3 --> Activa el pintado de las CRUCES del mouse
			if Globales.ms.b1 == 3:
				Globales.ms.b1 = 2
				cruz_dest.posicion = Utils.pantalla_to_universo(Globales.ms.pos)
				# ........................................ AJUSTE PUNTO CRUZ MULTIPLO de 5 ....
				cruz_dest.posicion= 5 * round(cruz_dest.posicion/5)
				# ......................................... FIN AJUSTE ........................
				cruz_dest.activa = true		# .. Se activa la cruz destino (Botoón 1)
				cruz_zona.activa = false	# -- Desactiva la cruz imagen
				queue_redraw()
				st_mundo = 2
				print ("st_mundo 1 -> 2: Espera llegada coche")
		2:	#.....ESPERANDO LLEGADA del COCHE al DESTINO
				var camara_en_movimiento: bool
				camara_en_movimiento = camara_sigue_coche()
				print("camara_en_movimiento: ", camara_en_movimiento)
				
				if !cruz_dest.activa && !camara_en_movimiento:
					cruz_zona.posicion = coche.coche_j.pos + coche.coche_j.vel
					cruz_zona.activa = true						# ACTIVA la cruz imagen
					queue_redraw()
					st_mundo = 1
					print ("st_mundo 2 -> 1: Espera b1")
		_:	#.....POR DEFECTO
			pass
				
		
	# ================= Pocesa: -ZOOM CÁMARA - ==============================================
	# Atiende a la RUEDA del Mouse
	if Globales.nuevo_zoom > 0.0:
		Globales.pantalla.zoom = Vector2(Globales.nuevo_zoom, Globales.nuevo_zoom)
		Globales.nuevo_zoom = 0
		queue_redraw()
	# Se han creado dos ACCIONES en el MAPA de ENTRADAS:  "+" -> "zoom+"  y  "-" -> "zoom-"
	else:
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
		Vector2(-0.5 ,0.5)*Constantes.TAMANO_MUNDO_METROS * Constantes.PxM,
		Vector2(0.5 ,-0.5)*Constantes.TAMANO_MUNDO_METROS * Constantes.PxM,
		Constantes.MxC,
		1
	)

	# ========= PINTA EJES ===================================================================
	pinta_eje_coordenadas(
		Vector2(0,0),
		Vector2(0.5 ,0.5)*Constantes.TAMANO_MUNDO_METROS,
		1
	)

	# ===== PINTAR CRUCES CON EL MOUSE ===================================================
	
	if cruz_zona.activa:
		pinta_cruz(
			cruz_zona.posicion,			# (m)
			cruz_zona.longitud,			# (pixel) Tamaño
			cruz_zona.color_cruz,		# Color
			cruz_zona.grosor			# (pixel) Grosor
		)
		var posicion: Vector2 = Vector2(cruz_zona.posicion.x, -cruz_zona.posicion.y) * Constantes.PxM
		#var velocidad: Vector2 = coche.coche_j.vel * Constantes.PxM
		var area_accesible: float = 5 * Constantes.PxM	# 0.5 * 10 * 1
		draw_arc(
			posicion,   			# centro
			area_accesible,			# radio
			0,                   	# inicio
			TAU,                 	# fin (2π)
			64,                  	# suavidad
			Color.RED,
			2                    	# grosor línea
	)
	if cruz_dest.activa:
		pinta_cruz(
			cruz_dest.posicion,			# (m)
			cruz_dest.longitud,			# (pixel) Tamaño
			cruz_dest.color_cruz,		# Color
			cruz_dest.grosor			# (pixel) Grosor
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
			grosor / Globales.pantalla.zoom.x
		)
	for x in range(ini.x, fin.x+dist.x, dist.x):
		draw_line(
			Vector2(x, ini.x),
			Vector2(x, fin.x),
			Constantes.GRID_COLOR_G,
			grosor / Globales.pantalla.zoom.x
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
		grosor / Globales.pantalla.zoom.x
	)
	# EJE X NEGATIVO (rojo -> discontinuo)
	draw_dashed_line(
		centro,
		Vector2(centro.x - long.x, centro.x),
		Color.RED,
		grosor / Globales.pantalla.zoom.x,
		50.0
	)
	# EJE Y POSITIVO (verde -> continuo)
	draw_line(
		centro,
		Vector2(centro.y, centro.y-long.y),
		Color.GREEN,
		grosor / Globales.pantalla.zoom.x,
		50.0
	)
	# EJE Y NEGATIVO (verde -> discontinuo)
	draw_dashed_line(
		centro,
		Vector2(centro.y, centro.y + long.y),
		Color.GREEN,
		grosor / Globales.pantalla.zoom.x,				#Grosor de la línea
		50.0				#Longitud de los segmentos
	)
	
	# ===== Pintar una CRUZ en el UNIVERSO ===================================================
func pinta_cruz(
		centro_m: Vector2,	# (m) Posición de la cruz
		largo: float,		# (pixel) Tamaño de la cruz
		color: Color,		# 
		grosor: float		# (pixsel) Grosor de las lineas de la cruz
	) -> void:
	
	var diametro_hueco= 2 * grosor / Globales.pantalla.zoom.x
	var centro: Vector2 = centro_m * Constantes.PxM
	# línea horizontal
	draw_line(
		Vector2(centro.x - largo, -centro.y),
		Vector2(centro.x -diametro_hueco, -centro.y),
		color,
		grosor / Globales.pantalla.zoom.x
	)
	draw_line(
		Vector2(centro.x +diametro_hueco, -centro.y),
		Vector2(centro.x + largo, -centro.y),
		color,
		grosor / Globales.pantalla.zoom.x
	)
	# línea vertical
	draw_line(
		Vector2(centro.x, -centro.y - largo),
		Vector2(centro.x, -centro.y -diametro_hueco),
		color,
		grosor / Globales.pantalla.zoom.x
	)
	draw_line(
		Vector2(centro.x, -centro.y +diametro_hueco),
		Vector2(centro.x, -centro.y + largo),
		color,
		grosor / Globales.pantalla.zoom.x
	)
	
	# La PANTALLA sigue al Coche
func camara_sigue_coche(
	) -> bool:
	var camara_en_posicion: bool= false
	var dif_posicion: Vector2
	var inc_posicion: Vector2 = Vector2(5,5)
	dif_posicion= (coche.position + Constantes.VECTOR_CAMARA * Constantes.PxM) - Globales.pantalla.position
	print("dif_posicion: ",dif_posicion)
	if absf(dif_posicion.x) > inc_posicion.x or abs(dif_posicion.y) > inc_posicion.y:
		# print("down 3: ",Globales.pantalla.position, " - ", dif_posicion)
		if dif_posicion.x > inc_posicion.x:
			Globales.pantalla.position.x += inc_posicion.x
		elif dif_posicion.x < -inc_posicion.x:
			Globales.pantalla.position.x -= inc_posicion.x
		else:
			Globales.pantalla.position.x += dif_posicion.x
		if dif_posicion.y > inc_posicion.y:
			Globales.pantalla.position.y += inc_posicion.y
		elif dif_posicion.x < -inc_posicion.y:
			Globales.pantalla.position.y -= inc_posicion.y
		else:
			Globales.pantalla.position.y += dif_posicion.y
	else:
		camara_en_posicion = true
	
	var camara_orientada: bool = false
	var dif_rotacion: float
	var inc_rotacion: float= PI/180
	dif_rotacion= coche.rotation - Globales.pantalla.rotation - Constantes.ROTACION_CAMARA
	if absf(dif_rotacion) > inc_rotacion:
		if dif_rotacion > inc_rotacion:
			Globales.pantalla.rotation += inc_rotacion
		elif dif_rotacion < -inc_rotacion:
			Globales.pantalla.rotation -= inc_rotacion
		else:
			Globales.pantalla.rotation = coche.rotation - Constantes.ROTACION_CAMARA
	else:
		camara_orientada = true
	return !camara_en_posicion || !camara_orientada
	
