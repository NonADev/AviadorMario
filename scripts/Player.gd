extends KinematicBody2D

export(Vector2) var RESPAWN_POSITION = Vector2(0, 0) #posição de respawn
export(int) var SPEED = 240 #velocidade de movimento
export(bool) var DOUBLE_JUMP = true #pulo duplo
export(int) var JUMP_HEIGHT = -390 #tamanho do pulo
export(int) var HEALTH_POINTS = 3 #pontos de vida
export(int) var Y_POSITION_TO_KILL = 650 #posicao Y para matar

const UP = Vector2(0, -1) #aponta onde é emcima no x e y
const GRAVITY = 14 #gravidade para afetar o player
var motion = Vector2() #movimento do Player
var extraJump = false #pulo duplo


#movimentação do Player
func playerMovement(leftButton, rightButton):
	motion.x = 0
	if(!is_on_floor()):
		$SpriteAnimation.play("Jump")
	if(Input.is_action_pressed(rightButton)): #andar para direita
		motion.x += 1
		if(is_on_floor()):
			$SpriteAnimation.play("Run")
		$SpriteAnimation.flip_h = false
	if(Input.is_action_pressed(leftButton)): #andar para esquerda
		motion.x -= 1
		if(is_on_floor()):
			$SpriteAnimation.play("Run")
		$SpriteAnimation.flip_h = true
	if(motion.x == 0): #seta animação idle caso esteja parado
		if(is_on_floor()):
			$SpriteAnimation.play("Idle")		


#se bater no teto, desacelera
func isOnCeilingRemoveYAcceleration(): 
	if(is_on_ceiling()): 
		motion.y = 24


#se estiver flutuando, desaselera o "andar"
func isFloatingSlowdown(acceleration): 
	if(!is_on_floor()):
		return acceleration-60
	else:
		return acceleration


#pulo e pulo duplo
func playerJump(button): 
	if(is_on_floor()): #pulo
		extraJump = true #reseta pulo duplo
		if(motion.y>0): #reseta gravidade minima
			motion.y=GRAVITY #movimento minimo para gravidade
		if(Input.is_action_just_pressed(button)): #Pulo no chão
			motion.y = JUMP_HEIGHT #distancia do pulo
	else: #se estiver voando animação de queda e pulo duplo
		if(DOUBLE_JUMP && Input.is_action_just_pressed(button) && extraJump): #Pulo extra
			extraJump = false #gasta o pulo
			motion.y = JUMP_HEIGHT*0.85 #distancia do pulo
			$SpriteAnimation.frame = 0 #reseta animação do pulo
		if(motion.y<GRAVITY*28): #atração da gravidade
			motion.y += GRAVITY #adição da gravidade


#evento de respawn por controle
func playerRespawn(button, respawn_position): 
	if(Input.is_action_just_pressed(button)):
		motion = Vector2(0,14) #reseta o motion para restar a movimentação e aceleração do personagem
		respawn(respawn_position)


#evento de respawn
func respawn(respawn_position): 
	position = respawn_position #altera o atributo hidden "position" do Player.


#controlador de comandos do player
func playerCommandsHandler(): 
	playerJump("ui_up") #pulo
	playerMovement("ui_left", "ui_right") #movimento lateral
	playerRespawn("ui_down", RESPAWN_POSITION) #respawn engalilhado na seta pra baixo


#dar dano em monstros do layer 3
func _on_Pes_body_entered(body):
	if(body.damage()): #caso os pes entrem em contato com o monstro, executa o damage, que caso mate, da um jump extra pro user
		motion.y = JUMP_HEIGHT #pula
		extraJump = true #dá o extra jump de volta


#Cura player
func applyHealOnPlayer(points):
	HEALTH_POINTS += points


#aplica dano no player
func applyDamageOnPlayer(points):
	if(HEALTH_POINTS>1):
		HEALTH_POINTS -= points
	else: #morte
		applyHealOnPlayer(3) #reseta o contador de vida
		applyDeathOnPlayer() #aplica morte


#aplica morte ao player
func applyDeathOnPlayer():
	get_tree().reload_current_scene()
	#respawn(RESPAWN_POSITION)  #LEGADO PELA MORTE RESETAR O SCENE ATUAL


#receber dano no layer 3
func _on_Damage_body_entered(_body):
	applyDamageOnPlayer(1)


#mata se sair da caixa de visão
func killByYPosition():
	if(position.y>Y_POSITION_TO_KILL):
		applyDamageOnPlayer(1)
		respawn(RESPAWN_POSITION) 


func _physics_process(_delta):
	var acceleration = SPEED #aceleração=velocidade-atrito
	acceleration = isFloatingSlowdown(acceleration) #se estiver no ar diminui aceleração lateral
	isOnCeilingRemoveYAcceleration() #retira acelleração caso bata no teto
	playerCommandsHandler() #todos comandos do player serão por esse controlador
	motion.x *= acceleration #aumenta velocidade de movimento
	killByYPosition() #mata se passar da posição
	move_and_slide(motion, UP) #movimenta o Player




