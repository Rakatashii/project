require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: 'password', password_confirmation: 'password')
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem Ipsum")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end
end