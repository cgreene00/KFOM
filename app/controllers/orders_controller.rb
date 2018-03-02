class OrdersController < ApplicationController
  before_action :check_for_profile
  
  def new
    @post = Post.find(params[:id])
    @order = @post.orders.build
  end
  
  def create
    @post = Post.find(params[:post_id])
    @order = @post.orders.build(order_params)
    @order.user = current_user
    if @order.save
      redirect_to post_path(@post.user)
    else
      render 'new'
    end
  end
  
  def edit
    @order = Order.find(params[:id])
    @post = @order.post
  end
  
  def update
    @order = Order.find(params[:id])
    @post = @order.post
    if @order.submitted?
      @post.update_post_order(@order.quantity.to_i * -1)
      @order.update_attribute(:submitted, false)     
    end    
    if @order.update_attributes(order_params)      
      redirect_to post_path(@post.user)
    else
      render 'edit'
    end
  end
  
  def show    
    @post = Post.find(params[:id])
    @orders = @post.orders.current
  end
  
  def index
    if current_user.profile.seller?
      @posts = current_user.posts.active
      render 'seller'
    else
      @orders = current_user.orders.current.group_by{|p| p.post.user}
      render 'buyer'
    end
  end
  
  def destroy
    order = Order.find(params[:id])
    order.post.update_post_order(-1 * order.quantity.to_i)
    order.delete
    redirect_to orders_path
  end
  
  def submit
    my_orders = current_user.orders.unsubmitted
    my_orders.each do |o|
      o.post.update_post_order(o.quantity)
      o.update_attribute(:submitted, true)
    end
  end
  
  
private
  def order_params
    params.require(:order).permit(:quantity)
  end
end
