class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end
  
  def facebook
    generic_callback('facebook')
  end
  
  def google
    generic_callback('google')
  end
  
  def generic_callback( provider )
    @identity = Identity.find_for_oauth env["omniauth.auth"]
    
    @user = @identity.user || current_user
    if @user.nil?
      #Check to see if email is alreay registered
      @user = User.find_by_email(@identity.email || "")
      if @user.nil?
        @user = User.create( email: @identity.email || "")
      end
      @identity.update_attribute( :user_id, @user.id)
    end
    
    if @user.email.blank? && !@identity.email.blank?
      @user.update_attribute( :email, @identity.email)
    end
  
    if @user.persisted?
      @identity.update_attribute( :user_id, @user.id)
      @user = FormUser.find @user.id
      sign_in_and_redirect @user, event: :authentiication
      set_flash_message( :notice, :success, kind: provider.capitalize) if is_navigational_format?
    else 
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  def upgrade
    scope = 'email'
    if params[:provider] == 'google'
      scope = 'userinfo.profile,userinfo.email,offline,https://www.googleapis.com/auth/admin.directory.user'
    end
    redirect_to user_omniauth_authorize_path( params[:provider]), flash: {scope: scope }
  end
  
  def setup
    request.env['omniauth.strategy'].options['scope'] = flash[:scope] || request.env['omniauth.strategy'].options['scope']
    render :text => 'Setup complete', :status => 404
  end
end
