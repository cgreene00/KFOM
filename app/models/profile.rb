class Profile < ActiveRecord::Base
  after_validation :strip_characters_from_phone_number, on: [:create, :update]
  belongs_to :user
  validates :seller, inclusion: { in: [true, false] }, on: :update
  validates :firstname, presence: true, on: :update
  validates :lastname, presence: true, on: :update
  validates_format_of :phone_number, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "- Phone numbers must be in xxx-xxx-xxxx format.", on: :update
  
  ::States = {  AK: "Alaska",
              AL: "Alabama",
              AR: "Arkansas",
              AS: "American Samoa",
              AZ: "Arizona",
              CA: "California",
              CO: "Colorado",
              CT: "Connecticut",
              DC: "District of Columbia",
              DE: "Delaware",
              FL: "Florida",
              GA: "Georgia",
              GU: "Guam",
              HI: "Hawaii",
              IA: "Iowa",
              ID: "Idaho",
              IL: "Illinois",
              IN: "Indiana",
              KS: "Kansas",
              KY: "Kentucky",
              LA: "Louisiana",
              MA: "Massachusetts",
              MD: "Maryland",
              ME: "Maine",
              MI: "Michigan",
              MN: "Minnesota",
              MO: "Missouri",
              MS: "Mississippi",
              MT: "Montana",
              NC: "North Carolina",
              ND: "North Dakota",
              NE: "Nebraska",
              NH: "New Hampshire",
              NJ: "New Jersey",
              NM: "New Mexico",
              NV: "Nevada",
              NY: "New York",
              OH: "Ohio",
              OK: "Oklahoma",
              OR: "Oregon",
              PA: "Pennsylvania",
              PR: "Puerto Rico",
              RI: "Rhode Island",
              SC: "South Carolina",
              SD: "South Dakota",
              TN: "Tennessee",
              TX: "Texas",
              UT: "Utah",
              VA: "Virginia",
              VI: "Virgin Islands",
              VT: "Vermont",
              WA: "Washington",
              WI: "Wisconsin",
              WV: "West Virginia",
              WY: "Wyoming"
        }
  class << self
    def sellers
      where("seller = ?", true)
    end
    
    def buyers
      where("seller = ?", false)
    end
  end      

  def min_order_not_met?
    order_total.to_f < minimum_order.to_f    
  end
  
  def update_subtotal(subTotal)
    total = order_total.to_f + subTotal.to_f
    update_attribute(:order_total, total)
  end
  
  def phone_formatted
    "(#{phone_number[0,3]})-#{phone_number[3,3]}-#{phone_number[6,4]}"
  end
  
  def group_percentage
    if minimum_order.to_f == 0.0
      100
    else
      total = order_total.to_f / minimum_order.to_f
      if total > 1
        100
      else
        total * 100
      end
    end
  end
  
  private
  def strip_characters_from_phone_number
    self.phone_number = phone_number.gsub(/\D/,'').to_i
  end
  
end
