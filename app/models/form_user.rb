class FormUser < User
  attr_accessor :current_password
  
  validates_presence_of :email, if: :email_required?
  validates_uniqueness_of :email, allow_blank: true, if: :email_changed?
  validates_format_of :email, with: Devise.email_regexp, allow_blank: true, if: :email_changed?
  
  validates_presence_of :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of :password, within: Devise.password_length, allow_blank: true
  
  def password_required?
    return false if email.blank?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
  
  def email_required?
    true
  end  
  
  def self.find_first_by_auth_conditions warden_conditions
    conditions = warden_conditions.dup
    if (email = conditions.delete(:email)).present?
      where(email: email.downcase).first
    elsif conditions.has_key?(:reset_password_token)
      where(reset_password_token: conditions[:reset_password_token]).first
    end
  end
  
end
  
