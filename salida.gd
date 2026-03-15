extends Node2D
#=============================================================================================
#	FICHERO: salida.gd
#	_ready()
#	INICIALIZA la CÁMARA
#	_process()
#	CAPTURA movimientos manuales de ROTACIÓN del teclado
#	CAPTURA movimientos manuales de la CÁMARA: ZOOM, ROTACIÓN y DESPLAZAMIENTO
#	CAPTURA Botones del MOUSE
#=============================================================================================
@onready var mundo = get_node("Mundo")		# Permite utilizar las funciones de Mundo

@onready var pantalla: Camera2D = get_node("Coche/Camara")
@onready var pantalla_dim: Vector2 = get_viewport().get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globales.flags.flag0:
		print("Salida _ready() -inicio")
	print("Nodo mundo: ", mundo)
	
	# ============== INICIALIZA la PANTALLA ==================================================
	Globales.cam.size_P= pantalla_dim
	# ============== INICIALIZA la PANTALLA ==================================================
	pantalla.enabled = true
	pantalla.position = Globales.cam.pos_U * Constantes.PxM
	pantalla.rotation = Globales.cam.rot_U
	pantalla.zoom = Vector2(Globales.cam.zoom, Globales.cam.zoom)

	if Globales.flags.flag0:
		print("Salida _ready() -final")
		
		
# ============================================================================================
#	_process
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#=============================================================================================
func _process(_delta):
	if Globales.flags.flag0 and Globales.flags.flag2 < 2:
		Globales.flags.flag2 += 1
		print("Salida _process() -inicio flag2: ", Globales.flags.flag2)
		
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
		#print(" [+] : Zoom ++: ",nuevo_zoom)
	
	if Input.is_action_pressed("zoom-"):
		nuevo_zoom = nuevo_zoom * (1/1.02)
		nuevo_zoom = clamp(nuevo_zoom, min_zoom, max_zoom)
		pantalla.zoom = Vector2(nuevo_zoom, nuevo_zoom)
		#print(" [-] : Zoom --: ",nuevo_zoom)
	
	# ================ ROTACIÓN CÁMARA MANUAL ================================================
	#	Utiliza la captura de eventos "func _input(event)" al inicio
	#	"<" rota la cámara a la izquierda. Shift + ">" rota hacia la izquierda.
	if accion_rot == "rotar_der":
		Globales.cam.rot_U += 2*PI/360				# Rota a la DERECHA
		pantalla.rotation = -Globales.cam.rot_U
		#print(" [Shift + >] : rotar_der: ",cam.rot_U)
	
	if accion_rot == "rotar_izq":
		Globales.cam.rot_U -= 2*PI/360
		pantalla.rotation = -Globales.cam.rot_U
		#print(" [ < ]: rotar_izq: ",cam.rot_U)
	
	# ===== DESPLAZAMIENTO CÁMARA en el UNIVERSO MANUAL ======================================
	# Utiliza las flecha de movimiento del teclado
	var inc_posX := float(0.1)
	var inc_posY := inc_posX
	if Input.is_action_pressed("ui_up"):
		Globales.cam.pos_U += Vector2(0,-inc_posY)	# Cámara ARRIBA
		pantalla.position = Globales.cam.pos_U * Constantes.PxM
		#print("+inc_posY", pantalla.position)
	
	if Input.is_action_pressed("ui_down"):
		Globales.cam.pos_U += Vector2(0,inc_posY)		# Cámara ABAJO
		pantalla.position = Globales.cam.pos_U * Constantes.PxM
		#print("-inc_posY", pantalla.position)
	
	if Input.is_action_pressed("ui_left"):
		Globales.cam.pos_U += Vector2(-inc_posX,0)	# Cámara IZQUIERDA
		pantalla.position = Globales.cam.pos_U * Constantes.PxM
		#print("-inc_posX", pantalla.position)
	
	if Input.is_action_pressed("ui_right"):
		Globales.cam.pos_U += Vector2(inc_posX,0)		# Cámara DERECHA
		pantalla.position = Globales.cam.pos_U * Constantes.PxM
		#print("+inc_posX", pantalla.position)
		
	if Globales.flags.flag0 and Globales.flags.flag2 < 2:
		Globales.flags.flag2 += 1
		print("Salida _process() -final  flag2: ", Globales.flags.flag2)

# ===== FIN func _process(_delta)
#=============================================================================================


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
		var eMM := event as InputEventMouseMotion # position, relative y velocity
		# print("MouseMotion: ", eMM)
		Globales.ms.pos = eMM.position
	#====== Captura BOTONES MOUSE=============================================================
	if event  is InputEventMouseButton:
		var eMB := event as InputEventMouseButton # 1,2,3,4 y 5 
		print("Salida - event MouseButton: ", eMB)
		# print("Salida - event Boton mouse: - index: b1= ", eMB.button_index)
		if eMB.button_index and MOUSE_BUTTON_MASK_LEFT:
			if eMB.pressed:
				Globales.ms.b1 = 3		# Boton + presset= true -> Flanco ON
			else:
				Globales.ms.b1 = 1		# Boton + presset= false -> Flanco OFF
		print("Salida - event Globales.ms.b1= ", Globales.ms.b1, "  3: flanco ON - 1: flanco OFF")
		
		
		
