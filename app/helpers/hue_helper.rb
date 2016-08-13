module HueHelper
  # Gets the IP address of the Philips Hue bridge if it is connected to the same network
  def hue_ip
    url = 'https://www.meethue.com/api/nupnp'
    resp = Faraday.get(url)
    parsed_resp = JSON.parse(resp.body)[0]

    parsed_resp['internalipaddress'] || false
  end

  def hue_api_url
    if hue_ip
      "http://" + hue_ip + "/api"
    else
      false
    end
  end

  # Gets user authorization for the Philips Hue bridge
  def get_hue_authorization
    # If Philips Hue bridge is connected
    if hue_api_url
      resp = Faraday.post(hue_api_url) do |request|
        request.body = {devicetype: "hue_app"}.to_json
        request.headers['Accept'] = "application/json"
      end

      parsed_resp = JSON.parse(resp.body)[0]

      # Respose from Philips Hue bridge
      if parsed_resp['error']
        {"success": false, "message": parsed_resp['error']['description']}
      else
        {
          "success": true,
          "message": "Success. Was able to connect with Philips Hue bridge and get authorization.",
          "username": parsed_resp['success']['username']
        }
      end

    # Philips Hue bridge is not connected
    else
      {
        "success": false,
        "message":  "There is no Philips Hue connected to your internet.Please make sure your Philips Hue bridge and lightbulbs are set up properly."
      }
    end
  end

  def whitelist_hue_app
    if cookies[:hue_username]
      true
    else
      resp = get_hue_authorization
      cookies[:hue_username] = resp[:username]
    end
  end

  def hue_username
    cookies[:hue_username]
  end
end
