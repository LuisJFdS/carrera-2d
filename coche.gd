extends Node2D

class Coche_Jugador:
	var dest: Vector2 = Vector2.ZERO
	var vel: Vector2 = Vector2.ZERO
var coche_j: = Coche_Jugador.new()

func _ready() -> void:
	# print("get_parent: ", get_parent())
	# print("get_parent().get_node('Mundo'): ", get_parent().get_node("Mundo"))
	pass
	
func _process(delta: float) -> void:
	var mundo: Node2D = get_parent().get_node("Mundo")			# Permite utilizar las funciones de Mundo
	
	if mundo.cruz1.destino_coche == true:
		mundo.cruz1.destino_coche = false
		coche_j.dest = mundo.cruz1.posicion
		coche_j.vel = mundo.cruz1.posicion - Vector2(position.x,-position.y)
				
	if absf(coche_j.vel.x)>0:
		if absf(coche_j.dest.x - position.x) < delta * absf(coche_j.vel.x):
			position.x = coche_j.dest.x
			coche_j.vel.x=0
		else:
			position.x += delta * coche_j.vel.x
	if absf(coche_j.vel.y)>0:
		if absf(coche_j.dest.y - (-position.y)) < delta * absf(coche_j.vel.y):
			position.y = (-coche_j.dest.y)
			coche_j.vel.y=0
		else:
			position.y += delta * (-coche_j.vel.y)
	
		
		

		
		
		
		
