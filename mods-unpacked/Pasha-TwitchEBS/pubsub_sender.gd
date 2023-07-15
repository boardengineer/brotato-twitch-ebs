extends Node

var http_request

const SEND_TIME = 3.0
var send_timer
var send_countdown

var url = "https://api.twitch.tv/helix/extensions/pubsub"

func _ready():
	http_request = HTTPRequest.new()
	
	send_timer = Timer.new()
	send_timer.wait_time = SEND_TIME
	send_timer.autostart = true
	send_timer.connect("timeout", self, "send_pubsub_request")
	add_child(send_timer)
	
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	
func send_pubsub_request():
	if not $"/root".has_node("AuthHandler"):
		return
		
	var twitch_jwt = $"/root/AuthHandler".jwt
	
	if not twitch_jwt or twitch_jwt == "":
		return
	
	var twitch_broadcaster_id = $"/root/AuthHandler".channel_id
	
	var result_dict = {}
		
	for effect_key in RunData.init_stats():
		result_dict[effect_key] = RunData.effects[effect_key]
			
	var weapons_array = []
	for weapon in RunData.weapons:
		var weapon_dict = {}
		weapon_dict["id"] = weapon.weapon_id
		weapon_dict["tier"] = weapon.tier
		weapons_array.push_back(weapon_dict)
	result_dict["weapons"] = weapons_array
			
	var items_array = []
	for item in RunData.items:
		var item_dict = {}
		item_dict["id"] = item.my_id
		items_array.push_back(item_dict)
	result_dict["items"] = items_array
	
	var body = to_json({"message": str(RunData.effects), "broadcaster_id": twitch_broadcaster_id, "target": ["broadcast"]})
		
	var headers = []
	headers.push_back(str("Authorization: Bearer ", twitch_jwt))
	headers.push_back("Client-Id: pdvlxh7bxab4z9hwj9sfb7qc2o6epp")
	headers.push_back("Content-Type:application/json")
	
	var error = http_request.request(url, headers, true, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _http_request_completed(_result, _response_code, _headers, _body):
	pass
