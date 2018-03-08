require 'test_helper'
# Test Sequence:
  # 1. Define a user variable using the fixtures.
  # 2. Call the remember meth to remember the given user
  # 3. Verify that current_user is equal to the given user
class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:michael)
    remember(@user)
  end
  test "#current_user returns the right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end
  test "#current_user returns nil when remember_digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end