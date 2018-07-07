class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :week
  has_many :orders, dependent: :destroy
  
  validates :max_avaliable, numericality: true, if: :has_max_quantity?
  
  Units = [
    "per pound",
    "per sack",
    "per bundle",
    "each"
  ]
  
  class << self
    def deactivate_listings
      #Order.unsubmitted.delete_all
      Order.current.update_all(archived: true, week_id: Week.last)
      Post.active.update_all(active: false, week_id: Week.last)
    end
    
    def active
      where("active = ?", true)
    end
    
    def inactive
      where("active = ? and archived = ?", false, false)
    end  
  end
  
  def update_post_order(num)
    prof = user.profile
    subtotal = price.to_f * num.to_i
    prof.update_subtotal(subtotal)
    if prof.order_total.to_f < 0
      prof.update_attributes(order_total: '0')
    end
    new_qty = max_avaliable.to_i - num.to_i
    update_attributes(max_avaliable: new_qty)
    if max_avaliable.to_i < 0
      update_attributes(max_avaliable: '0')
    end
  end

private
  def has_max_quantity?
    if max_avaliable.to_i < 0
      self.errors[:max_avaliable] << "Maximum avaliable quantity must be a positive number"
      return false
    end
    return true
  end
  
end
