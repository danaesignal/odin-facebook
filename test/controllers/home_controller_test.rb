require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should prompt for facebook login if not logged in" do
    get root_path
    assert_template "devise/sessions/new"
    assert_match "facebook", response.body
  end

  test "should render home#index if logged in" do
    sign_in @user
    get root_path

    assert_template "home/index"
    assert_match "Authorized", response.body
  end
end
