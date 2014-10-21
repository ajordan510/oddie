require 'test_helper'

class LiveControllerTest < ActionController::TestCase
  test "should get sign-up" do
    get :sign-up
    assert_response :success
  end

end
