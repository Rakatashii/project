class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log user in - No submit button until redirect provided
      log_in user
      redirect_to user # user is automatically gotten from user_url(user)
    else
      # Handle errors
      flash.now[:danger] = 'Invalid Email/Password Combination'
      render 'new'
    end
  end
  def destroy
  end
end
