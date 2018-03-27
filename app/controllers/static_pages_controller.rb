class StaticPagesController < ApplicationController
  def home # GET / (Where '/' is the root)
    if logged_in?
      @micropost = current_user.microposts.build 
      @feed_items = current_user.feed.paginate(page: params[:page])
      # = microposts, but safer
    end
  end
  def help # GET /help
  end
  def about # GET /about
  end
  def contact # Get /contact
  end
end
