require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new' # Why not 'sessions/create'? b/c the login validation fails and we want to re-render the 'sessions/new' page.
    assert_not flash.empty?
    get root_path # We want flash[:danger] to display an error message on the next rerendering of 'sessions/new', but don't want it to persist long enough to be displayed on the home page should the user click that instead of trying new login information.
    assert flash.empty?
  end
end
