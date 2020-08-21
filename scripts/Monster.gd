extends StaticBody2D

export(float) var DISTANCE = 115 #distancia para andar
export(bool) var CAN_WALK = true #pode andar?
export(bool) var IDLE_FLIP = false #

const SPEED = 0.5 #velocidade de movimento
const GRAVITY = 14 #gravidade para afetar o player
var flip = true #flipagem da imagem ao virar esquerda ou direita
var initial_position #posicao onde começa a andar
var final_position #posicao onde volta
var alive = true #esta vivo?
var can_change_walk; #se for idle no ready, ele não vai parar e voltar a andar


func _ready():
	get_parent().get_node("Player").connect("player_has_died", self, "revive") #comando para conectar um sinal custom
	can_change_walk = CAN_WALK
	if(CAN_WALK): #se pode andar, troca para a animação de andar
		$Sprite.play("Walk")
	initial_position = position.x #inicializa o initial_position para ser a posição onde foi andado
	final_position = initial_position + DISTANCE #posicao final é a inicial + distancia


func damage():
	$Shape.set_deferred("disabled", true) #desativa a caixa de colisão quando o montro toma dano
	get_node("Animation").play("Die") #ativa a animação de morte do $Animation
	alive = false #seta que o montro está morto
	return true #avisa que pode dar um pulo


func desactiveWalk(): 
	if(can_change_walk):
		CAN_WALK = false


func activeWalk():
	if(can_change_walk):
		CAN_WALK = true
		$Sprite.play("Walk")


func revive():
	alive = true
	$Shape.set_deferred("disabled", false)
	$Sprite.set_deferred("visible", true)


func removeBody():
	$Sprite.set_deferred("visible", false)


func _process(_delta):
	if(!CAN_WALK):
		if(alive):
			$Sprite.play("Idle")
		$Sprite.flip_h = IDLE_FLIP
	elif(initial_position <= final_position && flip):
		position.x += SPEED
		IDLE_FLIP = false
		$Sprite.flip_h = IDLE_FLIP
		if(position.x >= final_position):
			flip = false
	elif(initial_position <= position.x && !flip):
		position.x -= SPEED
		IDLE_FLIP = true
		$Sprite.flip_h = IDLE_FLIP
		if(position.x <= initial_position):
			flip =true
