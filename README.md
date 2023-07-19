# brotato-twitch-ebs
A mod loader-compatible mod for brotato that allows it to act as an extension backend service for a twitch extension

The app is configure to run for a particular client and url combo.

In order to set them to a custom extension, add the corresponding varabiles (client_id and netlify_url) to the twitch.auth.cfg.  Running the auth flow will create this. example: 

[auth]

refresh_token="abc"
client_id="xyz"
netlify_url="https://spiffy-moonbeam-925327.netlify.app/"

Creating a netlify app and extension:

1) Start a twitch extension
2) Start a netlify app
3) Copy the 3 functions from https://github.com/boardengineer/next-netlify-starter/tree/main/netlify/functions to your netlify app
4) In the Twitch extension dashboard add an entry to "OAuth Redirect URL" pointing to the auth function in netlify (e.g. https://spiffy-moonbeam-925327.netlify.app/.netlify/functions/auth)
5) Create three Environment variables in netlify CLIENT_ID, CLIENT_SECRET, and TWITCH_EXTENSION_SECRET and populate them with the values from the the twitch extension dashboard (note there are two different 'secret' values)
6) Copy the netlify url and client_id into the twitch.auth.cfg file for the mod