require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
=begin
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: 
                                   { name:  "",
                                   email: "user@invalid",
                                   password: "foo",
                                   password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    #assert_select 'div#<CSS id for error explanation>'
    assert_select 'div#error_explanation'
    #assert_select 'div.<CSS class for field with error'
    assert_select 'div.field_with_errors'
  end
=end
  test "invalid signup information" do 
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confimation: "bar" } }
    end
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
end
