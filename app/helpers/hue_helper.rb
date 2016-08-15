module HueHelper

  def set_hue_ip
    if !cookies[:hue_ip]
      url = 'https://www.meethue.com/api/nupnp'
      resp = Faraday.get(url)
      parsed_resp = JSON.parse(resp.body)[0]

      cookies[:hue_ip] = parsed_resp['internalipaddress']
    end
  end

  def get_hue_ip
    cookies[:hue_ip]
  end

  def hue_api_url
    set_hue_ip
    hue_ip = get_hue_ip

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

  # Finds the light's IP address and gets a username/token
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

  def bright_red_settings
    {:hue => 65535, :sat => 254, :bri => 254}
  end

  def dim_red_settings
    {:hue => 65535, :sat => 254, :bri => 100}
  end

  def bright_green_settings
    {:hue => 25500, :sat => 254, :bri => 254}
  end

  def dim_green_settings
    {:hue => 25500, :sat => 254, :bri => 100}
  end

  def bright_blue_settings
    {:hue => 46920, :sat => 254, :bri => 254}
  end

  def dim_blue_settings
    {:hue => 46920, :sat => 254, :bri => 100}
  end

  def color_select_options
    {
      "red bright": 1,
      "red dimmed": 2,
      "green bright": 3,
      "green dimmed": 4,
      "blue bright": 5,
      "blue dimmed": 6
    }
  end

  def color_settings_from_id(id)
    color_settings = {
      1 => bright_red_settings,
      2 => dim_red_settings,
      3 => bright_green_settings,
      4 => dim_green_settings,
      5 => bright_blue_settings,
      6 => dim_blue_settings
    }

    return color_settings[id]
  end

  def update_light(payload)
    puts !!payload["hue_ip"]
    puts !!payload["hue_username"]

    url = "http://" + payload["hue_ip"] + "/api/" + payload["hue_username"] + "/lights/1/state"

    puts url

    color_settings = color_settings_from_id(payload["color"].to_i)

    data = {
      on: payload["on"],
      hue: color_settings[:hue],
      bri: color_settings[:bri],
      sat: color_settings[:sat],
      transitiontime: 0
    }

    resp = Faraday.put(url) do |request|
      request.body = data.to_json
      request.headers['Accept'] = "application/json"
    end
  end
end
