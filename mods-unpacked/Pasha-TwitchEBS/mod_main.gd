extends Node

const MOD_DIR = "Pasha-TwitchEBS/"

var OAuthTokenFetcher = load("res://mods-unpacked/Pasha-TwitchEBS/oauth_token_fetcher.gd")
var PubsubSender = load("res://mods-unpacked/Pasha-TwitchEBS/pubsub_sender.gd")

func _init():
	var ext_dir = ModLoaderMod.get_unpacked_dir() + MOD_DIR + "extensions/"
	
	ModLoaderMod.install_script_extension(ext_dir + "ui/menus/pages/main_menu.gd")
	
func _ready():
	var auth_handler = OAuthTokenFetcher.new()
	auth_handler.set_name("AuthHandler")
	$"/root".call_deferred("add_child", auth_handler)
	
	var pubsub_sender = PubsubSender.new()
	$"/root".call_deferred("add_child", pubsub_sender)
	
