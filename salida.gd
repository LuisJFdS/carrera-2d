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
	#mundo = get_node("Mundo")						# Permite utilizar las funciones de Mundo
	Globales.pantalla = get_node("Mundo/Camara")
	Globales.node_coche = get_node("Coche")

	# ============== INICIALIZA la PANTALLA ==================================================
	Globales.pantalla.enabled = true
	Globales.pantalla.position = Vector2(Constantes.VECTOR_CAMARA * Constantes.PxM)
	Globales.pantalla.rotation = 0
	Globales.pantalla.zoom = Vector2(0.2,0.2)
	
	# ============== INICIALIZA el COCHE del JUGADOR =========================================
	Globales.node_coche.position= Vector2(0,0)

# ============================================================================================
#	_process
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#=============================================================================================
func _process(_delta):
	# ================ PROCESA -ROTACIÓN CÁMARA MANUAL- ======================================
	#	Utiliza la captura de eventos "func _input(event)" al inicio
	#	"<" rota la cámara a la izquierda. Shift + ">" rota hacia la izquierda.
	var centro_rotacion: Vector2 = Vector2(0,0)
	if Globales.ms.rot == 1:
		Utils.rotar_pantalla(
			centro_rotacion,
			-2*PI/360
		)
	if Globales.ms.rot == -1:
		Utils.rotar_pantalla(
			centro_rotacion,
			+2*PI/360
		)
		
	# ================ PROCESA -DESPLAZAMIENTO CÁMARA MANUAL- ================================
	# Utiliza las flecha de movimiento del teclado
	var inc_pos_camara := Vector2( 0.1, 0.1 )	# (m)
	if Input.is_action_pressed("ui_up"):
		Globales.pantalla.position.y -= inc_pos_camara.y * Constantes.PxM	# metros -> pixels
	if Input.is_action_pressed("ui_down"):
		print("down 1: ",Globales.pantalla.position.y)
		Globales.pantalla.position.y += inc_pos_camara.y * Constantes.PxM
		print("down 2: ",Globales.pantalla.position.y)
	if Input.is_action_pressed("ui_left"):
		Globales.pantalla.position.x -= inc_pos_camara.x * Constantes.PxM
	if Input.is_action_pressed("ui_right"):
		Globales.pantalla.position.x += inc_pos_camara.x * Constantes.PxM

				#==========================
