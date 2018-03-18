class AccountActivationsController < ApplicationController
  def edit # GET /users/:id/edit
    # @user = User.find(params[:id])
    # ^ this can be eliminated since, by the 'before_action' statement, @user is now defined in #correct_user
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account Activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid Activation Link!"
      redirect_to root_url
    end
  end
end
