extends Control

var hearts = 3 setget set_hearts

func set_hearts(value):
	hearts = clamp(value, 0, 3)
	for i in get_child(0).get_child_count():
		if(value>i):
			get_child(0).get_child(i).visible = true
		else:
			get_child(0).get_child(i).visible = false


func _ready():
	self.hearts = get_parent().get_parent().get_node("Player").HEALTH_POINTS
	get_parent().get_parent().get_node("Player").connect("health_has_changed", self, "set_hearts") #comando para conectar um sinal custom
	
