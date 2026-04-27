extends Node2D

@onready var mundo: Node2D = get_parent().get_node("Mundo")			# Permite utilizar las funciones de mundo.gd
class Coche_Jugador:
	const ALINEACION_UNIVERSO = PI
	var pos: Vector2 = Vector2.ZERO
	var rot: float = 0.0				# rad
	var dest: Vector2 = Vector2.ZERO	# (m)
	var vel: Vector2 = Vector2.ZERO		# (m)
	var acel: Vector2 = Vector2.ZERO	# (m/s2)
	var delta_suma: float = 0.0			# (seg)
	var automatico: bool = false
	
var coche_j: = Coche_Jugador.new()
var st_coche: int = 0

func _ready() -> void:
	coche_j.rot = 0
	rotation = coche_j.ALINEACION_UNIVERSO + coche_j.rot
	st_coche = 0
	print("st_coche 0: espera cruz_dest -> inicializa trayectoria")
	
func _process(delta: float) -> void:
	match st_coche:
		0:	#.....ESPERANDO DESTINO para el COCHE
			if mundo.cruz_dest.activa:
				coche_j.dest = mundo.cruz_dest.posicion			# (m)
				coche_j.delta_suma = 0.0
				# Pt= Po + Vo + 0,5 * a * t
				coche_j.pos = Vector2(position.x/Constantes.PxM, -position.y/Constantes.PxM)	# (m)
				coche_j.acel = 2 * (coche_j.dest - coche_j.pos - coche_j.vel)					# (m/s2)
				coche_j.automatico = true
				st_coche = 1
				print("st_coche 0 -> 1: desplaza el coche al destino, desactiva cruz_dest")
		1:	#.....Avanza el coche hasta el destino
			coche_j.delta_suma += delta
			if (coche_j.delta_suma < 1.0):		#..... DESPLAZA el COCHE
				coche_j.pos += coche_j.vel * delta + 0.5 * coche_j.acel * delta ** 2
				coche_j.vel += coche_j.acel * delta
			else:
				coche_j.pos = coche_j.dest
				coche_j.delta_suma -= delta
				coche_j.vel += coche_j.acel * (1 - coche_j.delta_suma)
				mundo.cruz_dest.activa = false
				st_coche = 0
				print("st_coche 1 -> 0: espera cruz_dest -> inicializa trayectoria")
			position = Vector2(coche_j.pos.x * Constantes.PxM, - coche_j.pos.y * Constantes.PxM)
			rotation =  coche_j.ALINEACION_UNIVERSO + coche_j.vel.angle_to(Vector2.DOWN)
		
