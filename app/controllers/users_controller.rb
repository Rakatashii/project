class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  def show # GET /users/:id
    @user = User.find(params[:id])
  end
  def new # GET /users/new
    @user = User.new
  end
  def create # POST /users
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user # params[:user][:id]
    else
      render 'new'
    end
  end
  def edit # GET /users/:id/edit
    # @user = User.find(params[:id])
    # ^ this can be eliminated since, by the 'before_action' statement, @user is now defined in #correct_user
  end
  def update # PATCH/PUT users/:id
    #@user = User.find(params[:id])
    # ^ this can be elimated since, by the 'before_action' statement, @user is now defined in #correct_user
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    # WATCH
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
      # ~else: no flash/no redirect, so access to :edit or :update granted
    end
    def correct_user
      @user = User.find(params[:id]) # This is how @user is defined for the #edit/#create methods
      redirect_to(root_url) unless current_user?(@user)
    end
end
