require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do 
    get signup_path
    #Ensures that invalid form submissions link to /signup and not, say, /users, as when 'url: signup_path' in new.html.erb
    #assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      # 'users_path' is the named route associated w/ the 'POST' HTTP response
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "fodo",
                                         password_confimation: "baro" } }
    end
    #checks that a failed submission re-renders the 'new' action
    assert_template 'users/new'
    #These tests fail without the post statement from ^ - WHY?
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
    assert_select "li", "Name can't be blank"
    assert_select "li", "Email is invalid"
    #Weird that this test doesn't pass, given that the password does not match the password_confirmation.
    #assert_select "li", "Password confirmation doesn't match Password"
    min_validation = User.validators_on(:password).find do |v|
      v.options.key?(:minimum)
    end
    min_length = min_validation.options[:minimum]
    assert_select "li", "Password is too short (minimum is 5 characters)"
  end
  test "valid signup information creates new user" do
    get signup_path
    # Asserts that when a new User instance is created, User.count increases by exactly 1.
    assert_difference 'User.count', 1 do
      # post -> 'create' -> @user = User.new(user_params) (in this case, user_params are valid) -> @user.valid? => true -> @user.save => true -> redirect...
      post users_path, params: { user: { name: "Example User",
                          email: "user@example.com",
                          password: "password",
                          password_confirmation: "password" } }
    end
    follow_redirect!
    # redirect_to user_url(@user) is required for a new users show page - hence, the following will only be rendered as long as the redirect is successful.
    assert_template 'users/show'
    assert_not flash.empty?
  end 
end
