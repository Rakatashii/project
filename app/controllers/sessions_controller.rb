class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]
      # Log user in
    else
      # Error
      render 'new' # Rerender w/ invalidation info
    end
  end
  def destroy
  end
end
