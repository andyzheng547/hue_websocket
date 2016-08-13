require 'test_helper'

class HueControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get hue_index_url
    assert_response :success
  end

end
