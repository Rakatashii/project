class StaticPagesController < ApplicationController
  def home # GET / (Where '/' is the root)
    @micropost = current_user.microposts.build if logged_in?
  end
  def help # GET /help
  end
  def about # GET /about
  end
  def contact # Get /contact
  end
end
