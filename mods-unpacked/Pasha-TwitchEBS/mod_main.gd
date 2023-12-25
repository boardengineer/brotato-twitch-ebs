extends Node

const PASHA_TWITCHEBS_DIR = "Pasha-TwitchEBS"

var OAuthTokenFetcher = load("res://mods-unpacked/Pasha-TwitchEBS/oauth_token_fetcher.gd")
var PubsubSender = load("res://mods-unpacked/Pasha-TwitchEBS/pubsub_sender.gd")

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

func _init(modloader = ModLoader) -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().plus_file(PASHA_TWITCHEBS_DIR)
	install_script_extensions()


func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.plus_file("extensions")
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("ui/menus/pages/main_menu.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("singletons/run_data.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("ui/menus/shop/stats_container.gd"))


func _ready():
	var auth_handler = OAuthTokenFetcher.new()
	auth_handler.set_name("AuthHandler")
	$"/root".call_deferred("add_child", auth_handler)

	var pubsub_sender = PubsubSender.new()
	pubsub_sender.name = "pubsubSender"
	add_child(pubsub_sender)

