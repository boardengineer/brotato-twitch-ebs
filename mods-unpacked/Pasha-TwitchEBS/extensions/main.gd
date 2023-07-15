extends "res://main.gd"

var http_request

var send_time = 3.0
var send_countdown

var twitch_jwt = ""
var twitch_broadcaster_id = ""

func _ready():
	http_request = HTTPRequest.new()
	read_creds_file()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	send_countdown = send_time
	
func _physics_process(delta):
	send_countdown -= delta
	
	if send_countdown <= 0:
		send_countdown = send_time
		
		var result_dict = {}
		
		for effect_key in RunData.init_stats():
			result_dict[effect_key] = RunData.effects[effect_key]
			
		if is_instance_valid(_player):
			var weapons_array = []
			for weapon in _player.current_weapons:
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
		
		print(result_dict)
		
		var item_ids = []
		for item in ItemService.items:
			item_ids.push_back(item.my_id)
		print(item_ids)
		
		
		
		var body = to_json({"message": str(RunData.effects), "broadcaster_id": twitch_broadcaster_id, "target": ["broadcast"]})
		
		
		var url = "https://api.twitch.tv/helix/extensions/pubsub"
		
		var headers = []
		headers.push_back(str("Authorization: Bearer ", twitch_jwt))
		headers.push_back("Client-Id: pdvlxh7bxab4z9hwj9sfb7qc2o6epp")
		headers.push_back("Content-Type:application/json")
		
		var error = http_request.request(url, headers, true, HTTPClient.METHOD_POST, body)
		if error != OK:
			push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	pass

func read_creds_file():
	var file = File.new()
	file.open("user://creds.txt", File.READ)
	twitch_broadcaster_id = file.get_line()
	twitch_jwt = file.get_line()
	file.close()
