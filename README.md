# Hue Websocket

A basic Rails application to control a Philips Hue lightbulb. The application finds the first Philips Hue lightbulb connected to the same network and stores the IP address of that lightbulb. The application needs authorization in order to make requests to the lightbulb.

The application uses Action Cable to connect the server and client via WebSocket connection. When the form is updated client side, it sends an event to the WebSocket server. Based on the event and info sent, it will make the HTTP request to the lightbulb to update the state.

# What can the application do

The lightbulb's state can be changed to different colors and on state. The lightbulb can be made red, green, and blue and can be turned on and off. If the party checkbox is checked, the server keeps updating the lightbulbs color until the form is updated again.

# Setup

1. Clone the repo

~~~
git clone https://github.com/andyzheng547/hue_websocket.git
~~~

2. Go into the folder and run `bundle install`

3. Open the application with 'rails server' or 'rails s'

4. Open up a browser and go to 'http://localhost:3000'

5. If you are running this for the first time, the application does not have authorization to make requests to the lightbulb. Press the big button on your Philips Hue bridge, then refresh the page within 30 seconds and it should have authorization.

6. Have fun playing with your lights
