extends Node

const MOD_DIR = "Pasha-TwitchEBS/"

var OAuthTokenFetcher = load("res://mods-unpacked/Pasha-TwitchEBS/oauth_token_fetcher.gd")

func _init():
	var ext_dir = ModLoaderMod.get_unpacked_dir() + MOD_DIR + "extensions/"
	ModLoaderMod.install_script_extension(ext_dir + "main.gd")
	
func _ready():
	$"/root".call_deferred("add_child",OAuthTokenFetcher.new())
