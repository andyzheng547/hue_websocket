App.hue = App.cable.subscriptions.create "HueChannel",
  connected: ->

  disconnected: ->

  speak: (payload) ->
    @perform 'speak', payload

  party: (payload) ->
    @perform 'party', payload

# Light controls
$(document).on "change", "#light-controls", ->
  color = $('#color-select').val();
  onStatus = $('#on').is(':checked');
  hueUsername = Cookies.get('hue_username');
  hueIP = Cookies.get('hue_ip');
  App.hue.speak({"color": color, "on": onStatus, "hue_username": hueUsername, "hue_ip": hueIP});

# Party button - Loop through the colors
$(document).on "change", "#party-button", ->
  party = $('#party-button').is(':checked');
  hueUsername = Cookies.get('hue_username');
  hueIP = Cookies.get('hue_ip');
  App.hue.party({"party": party, "hue_username": hueUsername, "hue_ip": hueIP});
