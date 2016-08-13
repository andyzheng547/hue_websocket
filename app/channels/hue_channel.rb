class HueChannel < ApplicationCable::Channel
  include HueHelper

  def subscribed
    @party_status = false
    stream_from 'hue'
  end

  def speak(payload)
    @party_status = false
    update_light(payload)
  end

  def party(payload)
    @party_status = payload["party"]

    party_settings = [1, 3, 5]
    party_index = 0

    if @party_status
      while @party_status
        settings = {
          "on" => true,
          "hue_username" => payload["hue_username"],
          "color" => party_settings[party_index]
        }
        update_light(settings)

        party_index += 1
        if party_index > party_settings.length - 1
          party_index = 0
        end
      end
    else
      update_light({
        "on" => false,
        "hue_username" => payload["hue_username"],
        "color" => party_settings[party_index]
      })
    end

  end

  private

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
      puts payload

      url = hue_api_url + "/" + payload["hue_username"] + "/lights/1/state"
      color_settings = color_settings_from_id(payload["color"].to_i)

      data = {
        on: payload["on"],
        hue: color_settings[:hue],
        bri: color_settings[:bri],
        sat: color_settings[:sat]
      }

      resp = Faraday.put(url) do |request|
        request.body = data.to_json
        request.headers['Accept'] = "application/json"
      end
    end

end
