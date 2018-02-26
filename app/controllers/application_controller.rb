class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  
  def after_sign_in_path_for(user)
    if user.profile.nil? || !user.profile.registered?
      account_type_profile_path user
    else
      if user.profile.seller?
        posts_path
      else
        posts_path
      end
    end
  end
  
  def check_for_profile
    if signed_in? && current_user.profile.nil? || !current_user.profile.registered?
      redirect_to account_type_profile_path current_user
    end
  end
end
