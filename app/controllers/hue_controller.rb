class HueController < ApplicationController
  include HueHelper

  def index
    set_hue_ip
    
    if !hue_username
      whitelist_hue_app
    end
  end
end
