class PostsController < ApplicationController
  before_action :check_for_profile
  def new
    @post = Post.new
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "#{@post.title} saved, add a new listing"
      redirect_to new_post_path
    else
      render 'new'
    end
  end
  
  def edit
    @post = current_user.posts.find(params[:id])
  end
  
  def update
    @post = current_user.posts.find(params[:id])
    if @post.update_attributes(post_params)
      redirect_to posts_path
    else
      render 'edit'
    end
  end

  def index
    if current_user.profile.seller?
      @active_posts = current_user.posts.active
      @inactive_posts = current_user.posts.inactive
    else
      @active_posts = Post.active.group_by{|p| p.user}
      @my_orders = current_user.orders.unsubmitted.group_by{|o| o.post.user}
    end
  end
  
  def show
    @active_posts = User.find(params[:id]).posts.active
    @my_orders = current_user.orders.unsubmitted.group_by{|o| o.post.user}
  end
  
  def destroy
    current_user.posts.find(params[:id]).delete
    redirect_to posts_path    
  end
  
  def touch
    post = Post.find(params[:id])
    post.update_attribute(:archived, true)
    newPost = post.dup
    newPost.active = true
    newPost.archived = false
    newPost.week_id = nil
    if newPost.save
      redirect_to edit_post_path newPost
    else
      flash[:danger] = "An error occured renewing post"
      redirect_to posts_path
    end
  end
  
  def minimum_order
    @min_order = current_user.profile
  end
  
  def update_minimum_order
    current_user.profile.update_attributes(min_order_params)
    redirect_to posts_path
  end
  
private
  def post_params
    params.require(:post).permit( :user_id, 
                                  :title, 
                                  :description,
                                  :price,
                                  :unit,
                                  :max_avaliable,
                                  :special_instructions)
  end
  
  def min_order_params
    params.require(:min_order).permit( :minimum_order )
  end
end
