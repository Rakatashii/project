require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                    email: "foo@invalid",
                                    password: "foo",
                                    password_confirmation: "foo" } }
    assert_template 'users/edit'
    # This second argument should be "The form contains 4 errors" - not really problematic...
    assert_select "div.alert", "The form contains 3 errors"
  end
  test "successful edit" do
    log_in_as(@user) 
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name, 
                                    email: email,
                                    password: "",
                                    password_confirmation: "" } } 
    # if edit is supposed to be successful, why is password/password_confirmation empty?
    # Note that the password and confirmation in Listing 10.11 are blank, which is convenient for users who don’t want to update their passwords every time they update their names or email addresses. - Why do we even provide the params?
    # Pry - user=User.second; user.authenticate("Jake6465")=>true; user.update_attributes(password: "", password_confirmation: ""); user.autheticate("Jake6465")=>true; user.authenticate("")=>false
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
