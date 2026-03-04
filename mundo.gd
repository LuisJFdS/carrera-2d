extends Node2D

# ====== CONFIGURACIÓN ======
const METROS_POR_CUADRO := 5.0
const PIXELES_POR_METRO := 50.0
const TAMANO_MUNDO_METROS := 5000.0   # 5 km
const GRID_COLOR := Color(1, 1, 1, 0.08)
const GRID_COLOR_R := Color(1, 0, 0, 0.15)
const GRID_COLOR_G := Color(0, 1, 0, 0.1)
const GRID_COLOR_B := Color(0, 0, 1, 0.1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Pintamos Mundo ...")
	queue_redraw()

func _draw():
	var grosor = get_viewport().get_camera_2d().zoom.x
	grosor = grosor + 1/grosor

	var mitad_mundo_px = (TAMANO_MUNDO_METROS * PIXELES_POR_METRO) * 0.5
	var paso_px = METROS_POR_CUADRO * PIXELES_POR_METRO

	# ========= CUADRÍCULA =========
	for x in range(-mitad_mundo_px, mitad_mundo_px + paso_px, paso_px):
		draw_line(
			Vector2(x, -mitad_mundo_px),
			Vector2(x,  mitad_mundo_px),
			GRID_COLOR_G,
			grosor
		)

	for y in range(-mitad_mundo_px, mitad_mundo_px + paso_px, paso_px):
		draw_line(
			Vector2(-mitad_mundo_px, y),
			Vector2( mitad_mundo_px, y),
			GRID_COLOR_R,
			grosor
		)

	# ========= EJES =========

	# EJE X POSITIVO (rojo continuo)
	draw_line(
		Vector2(0, 0),
		Vector2(mitad_mundo_px, 0),
		Color.RED,
		grosor
	)

	# EJE X NEGATIVO (rojo discontinuo)
	#draw_dashed_line(
		#Vector2(0, 0),
		#Vector2(-mitad_mundo_px, 0),
		#Color.RED,
		#3.0
	#)

	# EJE Y POSITIVO (verde continuo)
	draw_line(
		Vector2(0, 0),
		Vector2(0, -mitad_mundo_px),
		Color.GREEN,
		grosor
	)

	# EJE Y NEGATIVO (verde discontinuo)
	#draw_dashed_line(
		#Vector2(0, 0),
		#Vector2(0, mitad_mundo_px),
		#Color.GREEN,
		#3.0
	#)


# ==========================
# FUNCIÓN PARA LÍNEA DISCONTINUA
# ==========================

#func draw_dashed_line(from: Vector2, to: Vector2, color: Color, width: float):
#
	#var dash_length := 20.0
	#var gap_length := 20.0
#
	#var total_length := from.distance_to(to)
	#var direction := (to - from).normalized()
#
	#var drawn := 0.0
	#var current := from
#
	#while drawn < total_length:
		#var segment_end := current + direction * min(dash_length, total_length - drawn)
#
		#draw_line(current, segment_end, color, width)
#
		#current = segment_end + direction * gap_length
		#drawn += dash_length + gap_length


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
