extends StaticBody2D

export(float) var DISTANCE = 115;
export(bool) var WALK = true;
export(bool) var FLIP_SPRITE = false;

var flip = true;
var initial_position;
var final_position;
const SPEED = 0.5;

func _ready():
	$Sprite.play("Walk");
	initial_position = position.x;
	final_position = initial_position + DISTANCE;

func _process(_delta):
	if(!WALK):
		$Sprite.play("Idle");
		$Sprite.flip_h = true;
		return;
	elif(initial_position <= final_position && flip):
		position.x += SPEED;
		$Sprite.flip_h = false;
		if(position.x >= final_position):
			flip =false;
	elif(initial_position <= position.x && !flip):
		position.x -= SPEED;
		$Sprite.flip_h = true;
		if(position.x <= initial_position):
			flip =true;
