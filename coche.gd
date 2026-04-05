extends Node2D

class Coche_Jugador:
	var pos: Vector2 = Vector2.ZERO
	var rot: float = 0.0				# rad
	const ALINEACION_UNIVERSO = PI
	var dest: Vector2 = Vector2.ZERO	# (m)
	var vel: Vector2 = Vector2.ZERO
	var acel: Vector2 = Vector2.ZERO	# (m/s2)
	var delta_suma: float = 0.0			# (seg)
	var automatico: bool = false
var coche_j: = Coche_Jugador.new()

func _ready() -> void:
	coche_j.rot = 0
	rotation = coche_j.ALINEACION_UNIVERSO + coche_j.rot
	# print("get_parent: ", get_parent())
	# print("get_parent().get_node('Mundo'): ", get_parent().get_node("Mundo"))
	pass
	
func _process(delta: float) -> void:
	var mundo: Node2D = get_parent().get_node("Mundo")			# Permite utilizar las funciones de Mundo
	
	# Verifica si hay un DESTINO para el coche y lo activa.
	if mundo.cruz1.destino_coche == true:
		coche_j.dest = mundo.cruz1.posicion			# (m)
		coche_j.delta_suma = 0.0
		# Pt= Po + Vo + 0,5 * a * t
		coche_j.pos = Vector2(position.x/Constantes.PxM, -position.y/Constantes.PxM)	# (m)
		coche_j.acel = 2 * (coche_j.dest - coche_j.pos - coche_j.vel)					# (m/s2)
		print("INICIO t = ", String.num(coche_j.delta_suma, 3))
		print("P0: ", coche_j.pos, " V0: ", coche_j.vel, " a: ", coche_j.acel,  " dest: ", coche_j.dest)
		coche_j.automatico = true
		mundo.cruz1.destino_coche = false
		
	if coche_j.automatico:
		coche_j.delta_suma += delta
		if (abs(coche_j.delta_suma) < 0.04 or 0.96 < abs(coche_j.delta_suma)):
			print("t = ", String.num(coche_j.delta_suma, 3), "   ángulo: ", coche_j.vel.angle() * 180 / PI)
			
		if (coche_j.delta_suma < 1.0):
			coche_j.pos += coche_j.vel * delta + 0.5 * coche_j.acel * delta ** 2
			coche_j.vel += coche_j.acel * delta
		else:
			coche_j.pos = coche_j.dest
			var delta_ajustada = delta - (coche_j.delta_suma - 1)
			coche_j.vel += coche_j.acel * delta_ajustada
			coche_j.automatico = false
		
		position = Vector2(coche_j.pos.x * Constantes.PxM, - coche_j.pos.y * Constantes.PxM)
		rotation =  coche_j.ALINEACION_UNIVERSO + coche_j.vel.angle_to(Vector2.DOWN)
		
