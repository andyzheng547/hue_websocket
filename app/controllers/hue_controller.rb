class HueController < ApplicationController
  include HueHelper

  def index
    if !hue_username
      whitelist_hue_app
    end
  end
end
