extends Node2D

#	Captura los movimientos de rotación con ">" y "<"
var accion_rot : String = ""
func _input(event: InputEvent) -> void:
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

# Posición de la CAMARA
@onready var mundo: Node2D = get_node("Mundo")
# Posición INICIAL de la cámara
var cam_m := Vector2(30, 0)	# m
var rot_cam := PI/8			# Radianes
var zoom := 0.25  			# 1 metro = 50 píxeles
@onready var camara: Camera2D = $Coche/Camara

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Empieza la carrera ...")
	
	camara.enabled = true
	var pixeles_por_metro := 50.0
	camara.position = cam_m * pixeles_por_metro
	camara.rotation = rot_cam   # radianes
	camara.zoom = Vector2(zoom, zoom)
	print("Camara activada y posicionada")
	
	#var viewport_size := get_viewport().get_visible_rect().size
	#print("viewport_size:", viewport_size)
	# Colocamos el ORIGEN del universo (0,0) en su punto de pantalla
	#mundo.position = Utils.universo_a_pantalla(
		#cam_m,
		#rot_cam,
		#zoom,
		#viewport_size
	#)
	#var pos_pantalla = $Camera.unproject_position(Vector2.ZERO)
	#print(pos_pantalla)
	#pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
func _process(_delta):
	
	# Se han creado dos ACCIONES en el MAPA de ENTRADAS
	# "+" -> "zoom+"  y  "-" -> "zoom-"
	# ================= ZOOM
	var min_zoom := 0.1
	var max_zoom := 1.0
	var nuevo_zoom := camara.zoom.x
	if Input.is_action_pressed("zoom+"):
		nuevo_zoom = nuevo_zoom * 1.02
		nuevo_zoom = clamp(nuevo_zoom, min_zoom, max_zoom)
		camara.zoom = Vector2(nuevo_zoom, nuevo_zoom)
	if Input.is_action_pressed("zoom-"):
		nuevo_zoom = nuevo_zoom * (1/1.02)
		nuevo_zoom = clamp(nuevo_zoom, min_zoom, max_zoom)
		camara.zoom = Vector2(nuevo_zoom, nuevo_zoom)	
	
	# Utiliza la captura de eventos "func _input(event) al inicio
	# ================ ROTACIÓN
	var nueva_rot := camara.rotation
	if accion_rot == "rotar_der":
		nueva_rot = nueva_rot + 2*PI/360
		camara.rotation = nueva_rot
		#print(" Shift+> Greater: rotar_der: ",nueva_rot)
	if accion_rot == "rotar_izq":
		nueva_rot = nueva_rot - 2*PI/360
		camara.rotation = nueva_rot
		#print("< Less: rotar_izq: ",nueva_rot)
	
	# Utiliza las flecha de movimiento del teclado
	# ================= MOVER
	var nueva_pos := camara.position
	var inc_posX := float(10.0)
	var inc_posY := inc_posX
	if Input.is_action_pressed("ui_up"):
		nueva_pos = nueva_pos + Vector2(0,-inc_posY)
		camara.position = nueva_pos
		print("+inc_posY", camara.position)
	if Input.is_action_pressed("ui_down"):
		nueva_pos = nueva_pos + Vector2(0,inc_posY)
		camara.position = nueva_pos
		print("-inc_posY", camara.position)
	if Input.is_action_pressed("ui_left"):
		nueva_pos = nueva_pos + Vector2(-inc_posX,0)
		camara.position = nueva_pos
		print("-inc_posX", camara.position)
	if Input.is_action_pressed("ui_right"):
		nueva_pos = nueva_pos + Vector2(inc_posX,0)
		camara.position = nueva_pos
		print("+inc_posX", camara.position)
