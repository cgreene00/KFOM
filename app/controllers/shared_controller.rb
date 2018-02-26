class SharedController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  def index
    @active_posts = Post.active.group_by{|p| p.user}
    @my_orders = current_user.orders.unsubmitted.group_by{|o| o.post.user} if signed_in?
  end
end
