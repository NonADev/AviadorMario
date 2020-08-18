extends KinematicBody2D;

const UP = Vector2(0, -1);
const GRAVITY = 14;
const SPEED = 300;
const JUMP_HEIGHT = -455;
var motion = Vector2();
var extraJump = false;

func PlayerMovement(acceleration):
	if(!is_on_floor()):
		$SpriteAnimation.play("Jump");
	if(Input.is_action_pressed("ui_right")): #andar para direita
		motion.x = acceleration;
		if(is_on_floor()):
			$SpriteAnimation.play("Run");
		$SpriteAnimation.flip_h = false;
	elif(Input.is_action_pressed("ui_left")): #andar para esquerda
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


func Playerjump(): #pulo e pulo duplo
	if(is_on_floor()): #pulo
		extraJump = true; #reseta pulo duplo
		if(motion.y>0):
			motion.y=GRAVITY;
		if(Input.is_action_just_pressed("ui_up")): #Pulo no chão
			motion.y = JUMP_HEIGHT; #distancia do pulo
	else: #se estiver voando animação de queda e pulo duplo
		if(Input.is_action_just_pressed("ui_up") && extraJump): #Pulo extra
			extraJump = false; #gasta o pulo
			motion.y = JUMP_HEIGHT; #distancia do pulo
			$SpriteAnimation.frame = 0; #reseta animação do pulo
		if(motion.y<GRAVITY*28): #atração da gravidade
			motion.y += GRAVITY; #adição da gravidade


func _physics_process(_delta):
	var acceleration = SPEED; #aceleração=velocidade-atrito
	isOnCeilingRemoveYAcceleration();
	acceleration = isFloatingSlowdown(acceleration);
	isOnCeilingRemoveYAcceleration();
	PlayerMovement(acceleration);
	Playerjump();
	move_and_slide(motion, UP);
