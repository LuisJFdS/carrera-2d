extends Node2D
#=============================================================================================
#	FICHERO: salida.gd
#	CAPTURA movimientos manuales de ROTACIÓN del teclado
#	CAPTURA movimientos manuales de la CÁMARA: ZOOM, ROTACIÓN y DESPLAZAMIENTO
#	CAPTURA desplazamiento  y botones del MOUSE
#	func pinta_cruz (centro, tamaño, color ancho)
#=============================================================================================
const Cnt = preload("res://constantes.gd")		# cuando se necesiten

@onready var pantalla: Camera2D = $Coche/Camara
@onready var pantalla_dim: Vector2 = get_viewport().get_visible_rect().size
@onready var pantalla_centro: Vector2 = pantalla_dim * 0.5

class CamaraDatos:
	var pos_U : Vector2 = Vector2.ZERO			# Posición PUNTO universo
	var pos_P : Vector2 = Vector2.ZERO			# Posición PANTALLA
	var rot_U : float = 0.0						# Rotación UNIVERSO
	var zoom : float = 0.2						# Zoom
	var size_P : Vector2 = Vector2.ZERO			# TAMAÑO de PANTALLA
var cam := CamaraDatos.new()

class MouseDatos:
	var pos : Vector2 = Vector2.ZERO
	var b1 : int = 0
	var b2 : int = 0
	var b3 : int = 0
	var b45 : int =0
var ms := MouseDatos.new()

#====== Captura los movimientos de rotación con ">" y "<" ====================================
var accion_rot : String = ""
func _input(event) -> void:
	#====== Captura los movimientos de rotación con ">" y "<" ================================
	if event is InputEventKey and not event.echo:
		var ek := event as InputEventKey		#Teclado
		#if ek.keycode == 62 and ek.pressed: #OJO: Tecla ">" independiente
			#accion_rot = "rotar_der"
		#else:
			#accion_rot = ""
		if ek.keycode == 60 and ek.pressed:
			if ek.shift_pressed:
				accion_rot = "rotar_der"
			else:
				accion_rot = "rotar_izq"
		elif ek.keycode == 60 and not ek.pressed:
			accion_rot=""
	#====== Captura DESPLAZAMIENTO MOUSE======================================================
	if event is InputEventMouseMotion:
		var eMM := event as InputEventMouseMotion
		ms.pos = eMM.position
		#print("Mouse posición: ",eMM.position)
	#====== Captura BOTONES MOUSE=============================================================
	if event  is InputEventMouseButton:
		var eMB := event as InputEventMouseButton
		if eMB.button_index == MOUSE_BUTTON_MASK_LEFT:
			if eMB.pressed:
				ms.b1 = 1		# Flanco de BAJADA
			else:
				ms.b1 = 3		# Flanco de Subida

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Empieza la carrera ...")
	
	pantalla.enabled = true
	pantalla.position = cam.pos_U * Cnt.PxM
	pantalla.rotation = cam.rot_U
	pantalla.zoom = Vector2(cam.zoom, cam.zoom)
	print("Camara activada y posicionada")


# ============================================================================================
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
func _process(_delta):

	# ================= ZOOM CÁMARA MANUAL ===================================================
	# Se han creado dos ACCIONES en el MAPA de ENTRADAS
	# "+" -> "zoom+"  y  "-" -> "zoom-"
	
	var min_zoom := 0.1
	var max_zoom := 1.0
	var nuevo_zoom := pantalla.zoom.x
	if Input.is_action_pressed("zoom+"):
		nuevo_zoom = nuevo_zoom * 1.02
		nuevo_zoom = clamp(nuevo_zoom, min_zoom, max_zoom)
		pantalla.zoom = Vector2(nuevo_zoom, nuevo_zoom)
		print(" [+] : Zoom ++: ",nuevo_zoom)
	
	if Input.is_action_pressed("zoom-"):
		nuevo_zoom = nuevo_zoom * (1/1.02)
		nuevo_zoom = clamp(nuevo_zoom, min_zoom, max_zoom)
		pantalla.zoom = Vector2(nuevo_zoom, nuevo_zoom)
		#print(" [-] : Zoom --: ",nuevo_zoom)
	
	# ================ ROTACIÓN CÁMARA MANUAL ================================================
	#	Utiliza la captura de eventos "func _input(event)" al inicio
	#	"<" rota la cámara a la izquierda. Shift + ">" rota hacia la izquierda.
	if accion_rot == "rotar_der":
		cam.rot_U = cam.rot_U + 2*PI/360				# Rota a la DERECHA
		pantalla.rotation = -cam.rot_U
		print(" [Shift + >] : rotar_der: ",cam.rot_U)
	
	if accion_rot == "rotar_izq":
		cam.rot_U = cam.rot_U - 2*PI/360
		pantalla.rotation = - cam.rot_U
		print(" [ < ]: rotar_izq: ",cam.rot_U)
	
	# ===== DESPLAZAMIENTO CÁMARA en el UNIVERSO MANUAL ======================================
	# Utiliza las flecha de movimiento del teclado
	var inc_posX := float(0.1)
	var inc_posY := inc_posX
	if Input.is_action_pressed("ui_up"):
		cam.pos_U = cam.pos_U + Vector2(0,-inc_posY)	# Cámara ARRIBA
		pantalla.position = cam.pos_U * Cnt.PxM
		print("+inc_posY", pantalla.position)
	
	if Input.is_action_pressed("ui_down"):
		cam.pos_U = cam.pos_U + Vector2(0,inc_posY)		# Cámara ABAJO
		pantalla.position = cam.pos_U * Cnt.PxM
		print("-inc_posY", pantalla.position)
	
	if Input.is_action_pressed("ui_left"):
		cam.pos_U = cam.pos_U + Vector2(-inc_posX,0)	# Cámara IZQUIERDA
		pantalla.position = cam.pos_U * Cnt.PxM
		print("-inc_posX", pantalla.position)
	
	if Input.is_action_pressed("ui_right"):
		cam.pos_U = cam.pos_U + Vector2(inc_posX,0)		# Cámara DERECHA
		pantalla.position = cam.pos_U * Cnt.PxM
		print("+inc_posX", pantalla.position)

	# ===== PINTAR CRUCES CON EL MOUSE ======================================================
	if ms.b1 == 1:
		print("Antes de <Utils.pantalla_a_universo>", Utils)
		#var punto := Utils.pantalla_a_universo(
			#ms.pos,
			#pantalla_centro,
			#cam.pos_U,
			#cam.rot_U,
			#cam.zoom
			#)
		pinta_cruz(
			Vector2(15.0,15.0),	# Posición en metros
			1.0,				# Tamaño en metros
			Color.CRIMSON,		# Color
			5					# Grosor en pixeles
		)
		print("Cruz 15x, 15y")
		
	# ===== PROCESAMOS LOS BOTONES DEL MOUSE =================================================
	if ms.b1 == 1:
		ms.b1 = 2
	elif ms.b1 == 3:
		ms.b1 = 0

# ===== FIN func _process(_delta)
#=============================================================================================

# ===== Pintar una CRUZ ======================================================================
func pinta_cruz(
		centro: Vector2,
		tam: float,
		color: Color,
		ancho: float = 1.0
	) -> void:
	# línea horizontal
	draw_line(
		Vector2(centro.x - tam, centro.y),
		Vector2(centro.x + tam, centro.y),
		color,
		ancho
	)
	# línea vertical
	draw_line(
		Vector2(centro.x, centro.y - tam),
		Vector2(centro.x, centro.y + tam),
		color,
		ancho
	)
