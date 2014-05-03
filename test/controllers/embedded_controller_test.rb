require 'test_helper'

class EmbeddedControllerTest < ActionController::TestCase
  test "should get signing" do
    get :signing
    assert_response :success
  end

  test "should get requesting" do
    get :requesting
    assert_response :success
  end

  test "should get template_requesting" do
    get :template_requesting
    assert_response :success
  end

  test "should get oauth_demo" do
    get :oauth_demo
    assert_response :success
  end

end
