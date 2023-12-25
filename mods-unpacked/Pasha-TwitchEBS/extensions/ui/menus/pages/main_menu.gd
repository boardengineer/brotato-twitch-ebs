extends "res://ui/menus/pages/main_menu.gd"


var twitch_button

onready var Pasha_pubsub_sender = get_node("/root/ModLoader/Pasha-TwitchEBS/pubsubSender")


func _ready() -> void:
	if not $"/root".has_node("AuthHandler"):
		return

	var auth_handler = $"/root/AuthHandler"

	twitch_button = load("res://mods-unpacked/Pasha-TwitchEBS/TwitchAuthButton.tscn").instance()

	if auth_handler.jwt and auth_handler.jwt != "":
		make_button_green()

	add_child(twitch_button)
	move_child(twitch_button, 1)

	auth_handler.connect("auth_in_progress", self, "make_button_yellow")
	auth_handler.connect("auth_failure", self, "make_button_red")
	auth_handler.connect("auth_success", self, "make_button_green")
	twitch_button.connect("pressed", self, "start_twitch_auth")
	continue_button.connect("pressed", Pasha_pubsub_sender, "call_deferred", ["resume"])
	start_button.connect("pressed", Pasha_pubsub_sender, "call_deferred", ["resume"])


func start_twitch_auth() -> void:
	if not $"/root".has_node("AuthHandler"):
		return

	twitch_button.release_focus()

	$"/root/AuthHandler".get_auth_code()


func make_button_red() -> void:
	var stylebox_flat = twitch_button.get_stylebox("normal").duplicate()
	stylebox_flat.bg_color = Color(1,0,0)
	twitch_button.add_stylebox_override("normal", stylebox_flat)


func make_button_yellow() -> void:
	var stylebox_flat = twitch_button.get_stylebox("normal").duplicate()
	stylebox_flat.bg_color = Color(1,1,0)
	twitch_button.add_stylebox_override("normal", stylebox_flat)


func make_button_green() -> void:
	var stylebox_flat = twitch_button.get_stylebox("normal").duplicate()
	stylebox_flat.bg_color = Color(0,1,0)
	twitch_button.add_stylebox_override("normal", stylebox_flat)
