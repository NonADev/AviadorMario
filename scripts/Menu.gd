extends Control

export(String, FILE, "*.tscn") var scene;

func _on_Start_pressed():
	get_tree().change_scene(scene);


func _on_Quit_pressed():
	get_tree().quit(200);
