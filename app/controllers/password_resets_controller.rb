class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest # Comp to activation_digest.. Unlike that attribute, this one cannot be private since it is called in the PasswordResetsController.
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end
  def edit
  end
  def update
    if params[:user][:password].empty? #Case3: handles - a failed update (which initially looks "successful") due to an empty password and confirmation
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params) #Case4: handles - A successful update 
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      # ^ prevents users on, say, a public computer from clicking the link and changing the password, even if the user is logged out...
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit' #Case2: handles - A failed update due to an invalid password #No error/flash[:danger] ???
      # Error: "Password Confirmation doesn't match password"
      # Where does ^ come from?
    end
  end
  
  private
    
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    def get_user
      @user = User.find_by(email: params[:email])
    end
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url #path?
      end
    end
    
end
