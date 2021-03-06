ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  def is_logged_in?
    !session[:user_id].nil?
  end
  
  def log_in_as(user)
    session[:user_id] = user.id
  end
  # Add more helper methods to be used by ALL tests here...
end

class ActionDispatch::IntegrationTest # We need a version of #log_in_as that can be used in integration tests. As of now, the sessions meth can be manipulated in controller test, but not in integration tests - we do not have a sessions model (seems to be the reason?)
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
    # Since we post new session, session is created: this means that params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  end
end
  
