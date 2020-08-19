extends StaticBody2D

var flip = true;
var initial_position;
var final_position;
const SPEED = 0.5;

func _ready():
	$Sprite.play("Walk");
	initial_position = position.x;
	final_position = initial_position + 115;

func _process(delta):
	if(initial_position <= final_position && flip):
		position.x += SPEED;
		$Sprite.flip_h = false;
		if(position.x >= final_position):
			flip =false;
	elif(initial_position <= position.x && !flip):
		position.x -= SPEED;
		$Sprite.flip_h = true;
		if(position.x <= initial_position):
			flip =true;
