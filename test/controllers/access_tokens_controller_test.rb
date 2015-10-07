require 'test_helper'

class AccessTokensControllerTest < ActionController::TestCase
  test "should get redirect" do
    get :redirect
    assert_response :success
  end

  test "should get begin" do
    get :begin
    assert_response :success
  end

  test "should get success" do
    get :success
    assert_response :success
  end

end
