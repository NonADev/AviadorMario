extends KinematicBody2D;

export(Vector2) var RESPAWN_POSITION = Vector2(0, 0);
export(int) var SPEED = 300;
export(bool) var DOUBLE_JUMP = true;
export(int) var JUMP_HEIGHT = -390;

const UP = Vector2(0, -1);
const GRAVITY = 14;
var motion = Vector2();
var extraJump = false;


func playerMovement(leftButton, rightButton, acceleration):
	if(!is_on_floor()):
		$SpriteAnimation.play("Jump");
	if(Input.is_action_pressed(rightButton)): #andar para direita
		motion.x = acceleration;
		if(is_on_floor()):
			$SpriteAnimation.play("Run");
		$SpriteAnimation.flip_h = false;
	elif(Input.is_action_pressed(leftButton)): #andar para esquerda
		motion.x = -acceleration;
		if(is_on_floor()):
			$SpriteAnimation.play("Run");
		$SpriteAnimation.flip_h = true;
	else: #zerar movimento caso não continue andando
		motion.x = 0;
		if(is_on_floor()):
			$SpriteAnimation.play("Idle");


func isOnCeilingRemoveYAcceleration(): #se bater no teto, desacelera
	if(is_on_ceiling()): 
		motion.y = 24;


func isFloatingSlowdown(acceleration): #se estiver flutuando, desaselera o "andar"
	if(!is_on_floor()):
		return acceleration-95;
	else:
		return acceleration;


func playerJump(button): #pulo e pulo duplo
	if(is_on_floor()): #pulo
		extraJump = true; #reseta pulo duplo
		if(motion.y>0):
			motion.y=GRAVITY;
		if(Input.is_action_just_pressed(button)): #Pulo no chão
			motion.y = JUMP_HEIGHT; #distancia do pulo
	else: #se estiver voando animação de queda e pulo duplo
		if(DOUBLE_JUMP && Input.is_action_just_pressed(button) && extraJump): #Pulo extra
			extraJump = false; #gasta o pulo
			motion.y = JUMP_HEIGHT*0.85; #distancia do pulo
			$SpriteAnimation.frame = 0; #reseta animação do pulo
		if(motion.y<GRAVITY*28): #atração da gravidade
			motion.y += GRAVITY; #adição da gravidade


func playerRespawn(button, respawn_position): #evento de respawn
	if(Input.is_action_just_pressed(button)):
		motion = Vector2(0,14); #reseta o motion para restar a movimentação e aceleração do personagem
		position = respawn_position; #altera o atributo hidden "position" do Player.


func playerCommandsHandler(acceleration): #controlador de comandos do player
	playerMovement("ui_left", "ui_right", acceleration);
	playerJump("ui_up");
	playerRespawn("ui_down", RESPAWN_POSITION);


func _on_Pes_body_entered(body):
	motion.y = JUMP_HEIGHT;
	body.damage();


func _physics_process(_delta):
	var acceleration = SPEED; #aceleração=velocidade-atrito
	acceleration = isFloatingSlowdown(acceleration); #se estiver no ar diminui aceleração lateral
	isOnCeilingRemoveYAcceleration(); #retira acelleração caso bata no teto
	playerCommandsHandler(acceleration); #todos comandos do player serão por esse controlador
	move_and_slide(motion, UP);


