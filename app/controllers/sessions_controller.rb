class SessionsController < ApplicationController
  def new # GET /sessions/new
  end
  def create # POST /sessions
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # Log user in - No submit button until redirect provided
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to @user # immediately after creating the new user will redirect to user/that_user_id
    else
      # Handle errors
      flash.now[:danger] = 'Invalid Email/Password Combination'
      render 'new' # Renders the form, rather than redirecting to user/that_user_id for a successful creation
    end
  end
  def destroy # DELETE /sessions/:id
    log_out if logged_in? 
    redirect_to root_url # After logout, redirects to home page
  end
end
