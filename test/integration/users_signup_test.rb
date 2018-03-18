require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    # Something like pending emails to be sent... ???
    ActionMailer::Base.deliveries.clear
  end
  test "invalid signup information" do 
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confimation: "bar" } }
    end
    #checks that a failed submission re-renders the 'new' action
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'

  # BEFORE MAILER
=begin
    min_validation = User.validators_on(:password).find do |v|
      v.options.key?(:minimum)
    end
    min_length = min_validation.options[:minimum]
    assert_select "li", "Password is too short (minimum is 5 characters)"
=end
  end
  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { 
                        name: "Example User",
                        email: "user@example.com",
                        password: "password",
                        password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    # #assigns lets us access instance variables in the corresponding action, in this case 'create', which corresponds to a POST request, '/users/ URL, and users_path named route.
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect! # to? user [else root_url]
    assert_template 'users/show'
    assert is_logged_in?
  end 
  test "valid signup information creates new user" do
    get signup_path
    assert_difference 'User.count', 1 do
      # remember, post request for 'create' action
      post users_path, params: { user: { name: "Example User",
                          email: "user@example.com",
                          password: "password",
                          password_confirmation: "password" } }
    end
    follow_redirect!
    # redirect_to user_url(@user) is required for a new users show page - hence, the following will only be rendered as long as the redirect is successful.
    #assert_template 'users/show'
    #assert_not flash.empty?
    #assert is_logged_in?
  end 
end
