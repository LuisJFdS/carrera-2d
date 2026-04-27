extends Node	# Node: globales.  Al ser globales necesita un Nodo
#=============================================================================================
# FICHERO: utils.gd

# EVENTOS:
# 	Teclado, Mouse
# FUNCIONES:
# 	TRASLADAR puntos de pantalla a UNIVERSO
# 	ROTAR la CÁMARA


# ===========================================================================================
# EVENTOS ENTRADA:
# ===========================================================================================
#	_input (event): - InputEventKey - InputEventMouseMotion - InputEventMouseButton
#					  	accion_rot		G.ms.pos/rel/vel/on		 G.ms.b1 ... b5

func _input(event) -> void:
	
	#====== Captura ROTACION teclado con ">" y "<" ===========================================
	if event is InputEventKey and not event.echo:
		var ek := event as InputEventKey		#Teclado
		#print(ek)
		#if ek.keycode == 62 and ek.pressed: #OJO: Tecla ">" independiente
			#accion_rot = "rotar_der"
		#elif ek.keycode == 62 and not ek.pressed:
			#accion_rot=""
			
		if ek.keycode == 60 and ek.pressed:
			if ek.shift_pressed:
	#			accion_rot = "rotar_der"
				Globales.ms.rot = 1
			else:
	#			accion_rot = "rotar_izq"
				Globales.ms.rot = -1
		elif ek.keycode == 60 and not ek.pressed:
	#		accion_rot=""
			Globales.ms.rot = 0
			
	#====== Captura DESPLAZAMIENTO MOUSE======================================================
	if event is InputEventMouseMotion:
		var eMM := event as InputEventMouseMotion # position, relative y velocity
		var centro = get_viewport().get_visible_rect().size / 2
		Globales.ms.pos = eMM.position - centro
		Globales.ms.rel = eMM.relative - centro
		Globales.ms.vel = eMM.velocity
		Globales.ms.mov += 1			# permite verificar si se han hecho varios movimientos
		
	#====== Captura BOTONES MOUSE=============================================================
	if event  is InputEventMouseButton:
		var eMB := event as InputEventMouseButton # 1,2,3,4 y 5 
		#print("Salida - ", eMB)
		# .. BOTON b1
		if eMB.button_index == MOUSE_BUTTON_MASK_LEFT:
			if eMB.pressed:
				Globales.ms.b1 = 3		# Boton + presset= true -> Flanco ON
			else:
				Globales.ms.b1 = 1		# Boton + presset= false -> Flanco OFF
		# .. ZOMM
		var zoom : float= 0.0
		if eMB.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = Globales.pantalla.zoom.x * 1.05
		if eMB.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = Globales.pantalla.zoom.x / 1.05
		if zoom > 0.0:
			Globales.nuevo_zoom = clamp(zoom, Constantes.ZOOM_MIN, Constantes.ZOOM_MAX)
				
# ===========================================================================================
# FUNCIONES
# ===========================================================================================

# ===== TRASLADAR PUNTO de PANTALLA a UNIVERSO
func pantalla_to_universo(
	vector_pantalla: Vector2
	) -> Vector2:
	var punto: Vector2 = vector_pantalla / Globales.pantalla.zoom.x
	var punto_ejes: Vector2 = Globales.pantalla.position + punto.rotated(Globales.pantalla.rotation)
	punto_ejes.y = -punto_ejes.y
	return punto_ejes/Constantes.PxM
	
# ===== ROTAR la CÁMARA respecto a un PUNTO
func rotar_pantalla(
		centro_de_rotacion: Vector2,
		rotacion_radianes: float
	) -> void:
	var vector_a_rotar: Vector2 = Globales.pantalla.position - centro_de_rotacion
	var vector_rotado: Vector2 = vector_a_rotar.rotated(rotacion_radianes)
	Globales.pantalla.position = vector_rotado
	Globales.pantalla.rotation += rotacion_radianes
	
