class Week < ActiveRecord::Base
  has_many :orders
  has_many :posts
  
  class << self
    def add_week
      last_end = Week.last.end
      new_week = Week.new
      new_week.start = last_end + 1
      new_week.end = new_week.start + 6
      new_week.save      
    end
  end
end
