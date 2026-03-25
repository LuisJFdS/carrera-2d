extends Node2D
#=============================================================================================
#	FICHERO: salida.gd
#	_ready()
#	INICIALIZA la CÁMARA
#	_process()
#	CAPTURA movimientos del TECLADO de la CÁMARA: ZOOM, ROTACIÓN y DESPLAZAMIENTO
#	CAPTURA Botones del MOUSE
#=============================================================================================
var mundo: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mundo = get_node("Mundo")						# Permite utilizar las funciones de Mundo
	Globales.pantalla = get_node("Coche/Camara")

	# ============== INICIALIZA la PANTALLA ==================================================
	Globales.pantalla.enabled = true
	Globales.pantalla.position = Vector2.ZERO
	Globales.pantalla.rotation = 0
	Globales.pantalla.zoom = Vector2(0.2,0.2)


# ============================================================================================
#	_process
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#=============================================================================================
func _process(_delta):
	
	# ================ PROCESA -ROTACIÓN CÁMARA MANUAL- ======================================
	#	Utiliza la captura de eventos "func _input(event)" al inicio
	#	"<" rota la cámara a la izquierda. Shift + ">" rota hacia la izquierda.
	if accion_rot == "rotar_der":
		Utils.rotar_pantalla(
			Vector2(0.0,0.0),
			-2*PI/360
		)
		#Globales.pantalla.rotation -= 2*PI/360			#= -Globales.cam.rot_U
		#print("Salida - _process - [Shift + >] : rotar_der: ",Globales.pantalla.rotation)
	if accion_rot == "rotar_izq":
		Utils.rotar_pantalla(
			Vector2(0.0,0.0),
			+2*PI/360
		)
		#Globales.pantalla.rotation += 2*PI/360			#= -Globales.cam.rot_U
		#print("Salida - _process - [ < ]: rotar_izq: ",Globales.pantalla.rotation)
		
	# ================ PROCESA -DESPLAZAMIENTO CÁMARA MANUAL- ================================
	# Utiliza las flecha de movimiento del teclado
	var inc_pos_camara := Vector2( 0.1, 0.1 )	# (m)
	if Input.is_action_pressed("ui_up"):
		Globales.pantalla.position.y -= inc_pos_camara.y * Constantes.PxM	# metros -> pixels
	if Input.is_action_pressed("ui_down"):
		Globales.pantalla.position.y += inc_pos_camara.y * Constantes.PxM
	if Input.is_action_pressed("ui_left"):
		Globales.pantalla.position.x -= inc_pos_camara.x * Constantes.PxM
	if Input.is_action_pressed("ui_right"):
		Globales.pantalla.position.x += inc_pos_camara.x * Constantes.PxM

				#==========================


# ===========================================================================================
#								EVENTOS ENTRADA
#	_input (event): - InputEventKey - InputEventMouseMotion - InputEventMouseButton
#					  	accion_rot		G.ms.pos/rel/vel/on		 G.ms.b1 ... b5
# ===========================================================================================

var accion_rot : String = ""
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
				accion_rot = "rotar_der"
			else:
				accion_rot = "rotar_izq"
		elif ek.keycode == 60 and not ek.pressed:
			accion_rot=""
			
	#====== Captura DESPLAZAMIENTO MOUSE======================================================
	if event is InputEventMouseMotion:
		var eMM := event as InputEventMouseMotion # position, relative y velocity
		#print("MouseMotion: ", eMM)
		
		var centro = get_viewport().get_visible_rect().size / 2
		Globales.ms.pos = eMM.position - centro
		Globales.ms.rel = eMM.relative
		Globales.ms.vel = eMM.velocity
		Globales.ms.mov += 1			# permite verificar si se han hecho varios movimientos
		
	#====== Captura BOTONES MOUSE=============================================================
	if event  is InputEventMouseButton:
		var eMB := event as InputEventMouseButton # 1,2,3,4 y 5 
		#print("Salida - ", eMB)
		if eMB.button_index and MOUSE_BUTTON_MASK_LEFT:
			if eMB.pressed:
				Globales.ms.b1 = 3		# Boton + presset= true -> Flanco ON
			else:
				Globales.ms.b1 = 1		# Boton + presset= false -> Flanco OFF
