
module Wizard
  
  module Profile
    STEPS = %w(account_type residential_info terms).freeze

    class Base
      include ActiveModel::Model
      attr_accessor :profile

      delegate *::Profile.attribute_names.map { |attr| [attr, "#{attr}="] }.flatten, to: :profile

      def initialize(profile_attributes)
        @profile = ::Profile.new(profile_attributes)
      end
    end

    class AccountType < Base
      validates :seller, inclusion: { in: [true, false] }
    end

    class ResidentialInfo < AccountType
      validates :firstname, presence: true
      validates :lastname, presence: true
      validates_format_of :phone_number, with: /\(?[0-9]{3}\)?-[0-9]{3}-[0-9]{4}/, message: "- Phone numbers must be in xxx-xxx-xxxx format."
    end
    
    class Terms < ResidentialInfo
      validates :terms_of_service, acceptance: { accept: true }
    end

  end
end
