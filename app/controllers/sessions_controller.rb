class SessionsController < ApplicationController
  def new
  end
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # Log user in - No submit button until redirect provided
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to @user # user is automatically gotten from user_url(user) (i.e., user/1 ??)
    else
      # Handle errors
      flash.now[:danger] = 'Invalid Email/Password Combination'
      render 'new'
    end
  end
  def destroy
    log_out if logged_in? # How do we get self here?
    # Don't need it. log_in and log_out operate on @current_user
    redirect_to root_url
  end
end
