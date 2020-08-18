extends Node

const gameTitle = "Game v0.1";

func getFPS():
	return str(Engine.get_frames_per_second());


func _process(_delta):
	OS.set_window_title(gameTitle+" | "+getFPS()+" FPS");
