module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  def log_out
    forget(current_user)
    session.delete(:user_id) # Why not destroy (sessions_controller.rb)? Where is #delete even defined?
    @current_user = nil
  end
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif cookies.signed[:user_id]
      # Why does Hartl replace 'cookies.signed[:user_id]) w/ 'user_id'? How can those two be equivalent?
      user = User.find_by(id: user_id)
      # user.authenticated?(cookies[:remember_token]) basically says, if BCrypt_operation(remember_token) == remember_digest...
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  def logged_in?
    !current_user.nil?
  end
# COMMENTED METH: generates a remember token and saves its digest to the User db
=begin
  def remember # FROM models/user.rb
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    # Why not update_attribute(remember_digest: User.digest(remember_token))???
  end
=end
# Uses cookies to create permanent cookies for the user id and remember token as described above.
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
