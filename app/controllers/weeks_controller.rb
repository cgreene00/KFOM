class WeeksController < ApplicationController
  def index
    @weeks = current_user.orders.archived.order(:week_id).group_by(&:week)
  end
  
  def show
    @orders = current_user.orders.archived.where(week_id: params[:id]).group_by{|o| o.post.user}
  end
  
end
