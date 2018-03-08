require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # from "michael: ..." in fixtures
    # Notice, user will not have remember_digest attr.
  end
  test "login with valid information" do
    post login_path, params: { session: { email: @user.email,                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user # If login succeeds (which it should, based on the custom fixture, then 'redirected_to @user' should be true.
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    
    # Simulate a user clicking logout in a second window
    delete logout_path # Tests failing b/c of this rn
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
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
