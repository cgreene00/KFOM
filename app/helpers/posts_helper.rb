module PostsHelper

  def correct_user(post)
    if(signed_in?)
      current_user.id == post.user.id
    end
  end
  
  def buyer?
    if signed_in? 
      !current_user.profile.seller?
    end
  end
  
  def has_order?(post)
    if post.orders.select{|s| s.user_id == current_user.id}.count > 0
      @order = current_user.orders.find_by_post_id(post.id)
      return true
    end
	
	@order = nil
    return false
  end
end
