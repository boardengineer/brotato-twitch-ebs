extends Node

var port := 31419
var binding := "localhost"
var client_id = "pdvlxh7bxab4z9hwj9sfb7qc2o6epp"
var auth_server = "https://id.twitch.tv/oauth2/authorize"

var redirect_server := TCP_Server.new()
#var redirect_uri := "http://%s:%s" % [binding, port]
var redirect_uri := "https://spiffy-moonbeam-925327.netlify.app/.netlify/functions/hello"

func _ready():
	print_debug("we are here")
	set_process(false)
	get_auth_code()

func _process(_delta):
	if redirect_server.is_connection_available():
		var connection = redirect_server.take_connection()
		var request = connection.get_string(connection.get_available_bytes())
		
		var page = """
Hello world?
		"""
		
		if request:
			print_debug("request ", request)
			
			var access_token = request.split("access_token=")[1].split("&")[0]
			var refresh_token = request.split("refresh_token=")[1].split("&")[0]
			var expires_in = int(request.split("expires_in=")[1].split("&")[0])
			
			print_debug("access_token ", access_token, " refresh_token ", refresh_token, " expires_in ", expires_in)
			
			var http_request = HTTPRequest.new()
			add_child(http_request)
			
			var headers = []
			headers.push_back(str("Authorization: Bearer ", access_token))
			
			var url = "https://spiffy-moonbeam-925327.netlify.app/.netlify/functions/jwt?access_token=" + access_token 
		
		
			http_request.connect("request_completed", self, "_http_request_completed")
		
			var error = http_request.request(url, headers, false, HTTPClient.METHOD_GET)
			if error != OK:
				print_debug("An error occurred in the HTTP request.")
			print_debug("request sent? ", error)
			
			
			connection.put_data("HTTP/1.1 200\r\n".to_ascii())
			connection.put_data(page.to_ascii())
			redirect_server.stop()
#			set_process(false)

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	print_debug("body ", body.get_string_from_ascii())
	pass

func get_auth_code():
	set_process(true)
	
	var _redir_error = redirect_server.listen(port)
	
	var body_parts = [
		"response_type=%s"    % "code",
		"client_id=%s"        % client_id,
		"redirect_uri=%s"     % redirect_uri,
		"scope=%s"            % "channel%3Amanage%3Apolls+channel%3Aread%3Apolls",
	]
	
	var url = auth_server + "?" + PoolStringArray(body_parts).join("&")
	
	OS.shell_open(url)
