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

    # Loop through colors: red, green, blue
    if @party_status
      # Loop
      while @party_status
        settings = {
          "on" => true,
          "hue_username" => payload["hue_username"],
          "color" => party_settings[party_index]
        }
        update_light(settings)

        # Update party_index
        party_index += 1
        if party_index > party_settings.length - 1
          party_index = 0
        end
      end
      # End of loop

    # Turn off lights
    else
      settings = {
        "on" => false,
        "hue_username" => payload["hue_username"],
        "color" => party_settings[party_index]
      }

      update_light(settings)
    end
  end
end
