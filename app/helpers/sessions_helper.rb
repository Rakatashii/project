module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  def logged_in?
    !current_user.nil?
  end
  def log_out
    forget(current_user)
    session.delete(:user_id) # Why not destroy (sessions_controller.rb)? Where is #delete even defined?
    @current_user = nil
  end
  def current_user
    if (user_id = session[:user_id]) # i.e., if the user is logged in (has a session w/ user's id)
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) 
      #raise # The tests still pass, so this branch is currently untested
      user = User.find_by(id: user_id)
# user.authenticated?(cookies[:remember_token]) basically says, if BCrypt_operation(remember_token) == remember_digest...
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    # Once this is defined we update 'log out' w/ forget(current_user)
  end
end
