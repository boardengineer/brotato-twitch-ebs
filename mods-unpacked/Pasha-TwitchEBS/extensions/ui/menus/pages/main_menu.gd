extends "res://ui/menus/pages/main_menu.gd"

var twitch_button

func _ready():
	if not $"/root".has_node("AuthHandler"):
		return
		
	var auth_handler = $"/root/AuthHandler"
	auth_handler.connect("auth_in_progress", self, "make_button_yellow")
	auth_handler.connect("auth_failure", self, "make_button_red")
	auth_handler.connect("auth_success", self, "make_button_green")
	
	twitch_button = load("res://mods-unpacked/Pasha-TwitchEBS/TwitchAuthButton.tscn").instance()
	twitch_button.connect("pressed", self, "start_twitch_auth")
	
	if auth_handler.jwt and auth_handler.jwt != "":
		make_button_green()
	
	add_child(twitch_button)
	move_child(twitch_button, 1)

func start_twitch_auth():
	if not $"/root".has_node("AuthHandler"):
		return
		
	$"/root/AuthHandler".get_auth_code()

func make_button_red():
	var stylebox_flat := StyleBoxFlat.new()
	stylebox_flat.bg_color = Color(1,0,0)
	twitch_button.add_stylebox_override("normal", stylebox_flat)
	
func make_button_yellow():
	var stylebox_flat := StyleBoxFlat.new()
	stylebox_flat.bg_color = Color(1,1,0)
	twitch_button.add_stylebox_override("normal", stylebox_flat)
	
func make_button_green():
	var stylebox_flat := StyleBoxFlat.new()
	stylebox_flat.bg_color = Color(0,1,0)
	twitch_button.add_stylebox_override("normal", stylebox_flat)
