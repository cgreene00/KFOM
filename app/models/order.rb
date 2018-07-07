class Order < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :week
  
  validates :quantity, numericality: true, if: :maximum_avaliable?, on: :create
  validates :quantity, numericality: true, if: :updated_max_avaliable?, on: :update
  
  class << self
     def submitted
      where("submitted = ?", true)
    end
    
    def unsubmitted
      where("submitted = ? and archived = ?", false, false)
    end
    
    def current
      where("submitted = ? and archived = ? and cancelled = ?", true, false, false)
    end
    
    def cancelled
      where("submitted = ? and archived = ? and cancelled = ?", true, false, true)
    end
    
    def archived
      where("submitted = ? and archived = ? and cancelled = ?", true, true, false)
    end
    
    def cancel_orders
      profiles = Profile.sellers
      profiles.each do |profile|
        if profile.min_order_not_met?
          posts = profile.user.posts
          posts.each do |p|
            p.orders.update_all(cancelled: true, week_id: Week.last.id)
          end
          OrderMailer.send_seller_cancelled(profile).deliver_now         
        end
      end
    end
  end
  
private
  def maximum_avaliable?
    if quantity.to_i <= 0
      self.errors[:quantity] << "Quantity must be greater than 0"
      return false
    elsif quantity.to_i > post.max_avaliable.to_i
      self.errors[:quantity] << "Maximum avaliable quantity is #{post.max_avaliable}"
      return false
    end
    return true
  end
  
  def updated_max_avaliable?
    if quantity.to_i <= 0
      self.errors[:quantity] << "Quantity must be greater than 0"
      return false
    elsif (quantity.to_i - quantity_was.to_i) > post.max_avaliable.to_i
      self.errors[:quantity] << "Maximum avaliable quantity is #{post.max_avaliable.to_i + quantity_was.to_i}"
      return false
    end
    return true
  end
end
