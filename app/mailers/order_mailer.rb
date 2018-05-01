class OrderMailer < ApplicationMailer

  default from: 'no-reply@kfom.org'
  
  def send_single_buyer_reminder(user, week)
    @user = user
    @order_items = user.orders.where(week: week).group_by{|o| o.post.user}
    mail(to: user.email, subject: "Order Reminder")
  end
  
  def self.buyer_reminder
    orders = Order.current.group_by{|o| o.user}
    orders.each do |user, items|
      if !user.email.nil?
        send_buyer_reminder(user.email, items).deliver_now
      end
    end
  end
  
  def send_buyer_reminder(email, items)
    @order_items = items.group_by{|o| o.post.user}
    mail(to: email, subject: "Order Reminder")
  end
  
  def self.seller_reminder
    sellers = Profile.where("seller = ?", true)
    sellers.each do |s|
      if !s.user.email.nil?
        if Order.current.where(post_id: s.user.posts.active.pluck(:id)).any?
          posts = s.user.posts.active
          send_seller_reminder(s.user.email, posts).deliver_now
        end
      end
    end
  end
  
  def send_seller_reminder(email, posts)
    @orders = Order.current.where(post_id: posts.pluck(:id)).group_by{|o| o.user}
    mail(to: email, subject: "Orders Reminder")
  end
  
  def cancelled_orders
    Order::cancel_orders
    orders = Order.cancelled.group_by{|o| o.user}
    orders.each do |user, items|
      send_cancelled_orders(user.email, items).deliver_now
    end
  end
  
  def send_cancelled_orders(email, items)
    @cancelled_items = items.group_by{|o| o.post.user}
    mail(to: email, subject: "Cancelled Orders")
  end
  
  def send_seller_cancelled(profile)
    @profile = profile
    mail(to: profile.user.email, subject: "Cancelled Listings")
  end
  
  def weekly_order_summary
    @orders = Order.current.joins(user: :profile).order("profiles.lastname").group_by(&:user)
    @week = Week.last
    mail(to: 'Merritt.Driscoll@sharecare.com',bcc: 'Katie.Swanson@sharecare.com', subject: 'Weekly Summary')
  end
  
  def weekly_seller_summary
    @users = User.includes(:profile).order("profiles.business_name").joins(posts: :orders).where("post_id = orders.post_id and orders.week_id = ?", Week.last).distinct
    @week = Week.last
    mail(to: 'Katie.Swanson@sharecare.com', bcc: 'Merritt.Driscoll@sharecare.com', subject: 'Sellers weekly summary')
  end
  
end
