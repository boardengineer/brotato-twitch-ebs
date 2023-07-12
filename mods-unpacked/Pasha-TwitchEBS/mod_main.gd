extends Node

const MOD_DIR = "Pasha-TwitchEBS/"

func _init():
	var ext_dir = ModLoaderMod.get_unpacked_dir() + MOD_DIR + "extensions/"
	ModLoaderMod.install_script_extension(ext_dir + "main.gd")
	
