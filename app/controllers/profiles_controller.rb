class ProfilesController < ApplicationController
  before_action :load_profile_wizard, except: [:edit, :update, :show, :validate_step]
  
  def create
    if current_user.profile.nil?
      @profile_wizard.profile.user_id = current_user.id
      profile = @profile_wizard.profile
    else
      
      current_user.build_profile(@profile_wizard.profile.attributes)
      profile = current_user.profile
    end
    if profile.save
        profile.update_attribute(:registered, true)
        UserMailer.welcome(profile.user).deliver_now
      session[:profile_attributes] = nil
      flash[:success] = "Profile updated"
      redirect_to posts_path
    else
      redirect_to({ action: Wizard::Profile::STEPS.first }, alert: 'There were a problem when creating the profile.')
    end
  end
  
  def edit
    @profile = current_user.profile
  end
  
  def update
    @profile = current_user.profile
    if @profile.update_attributes(profile_params)
      redirect_to posts_path
    else
      render 'edit'
    end
  end
  
  def show
    @profile = Profile.find(params[:id])
  end
  
  def validate_step
    current_step = params[:current_step]
    
    @profile_wizard = wizard_profile_for_step(current_step)
    @profile_wizard.profile.attributes = profile_wizard_params
    session[:profile_attributes] = @profile_wizard.profile.attributes

    if @profile_wizard.valid?
      next_step = wizard_profile_next_step(current_step)
      create and return unless next_step
    
      redirect_to action: next_step
    else
      render current_step
    end
  end
  
private
  def profile_wizard_params
    params.require(:profile_wizard).permit( :user_id,
                                            :seller,
                                            :firstname,
                                            :lastname,
                                            :business_name,
                                            :payable_to,
                                            :address,
                                            :city,
                                            :state,
                                            :zipcode,
                                            :phone_number,
                                            :terms_of_service)
  end
  
  def profile_params
    params.require(:profile).permit(  :seller,
                                      :firstname,
                                      :lastname,
                                      :business_name,
                                      :payable_to,
                                      :address,
                                      :city,
                                      :state,
                                      :zipcode,
                                      :phone_number)
  
  end
  
  def load_profile_wizard
    @profile_wizard = wizard_profile_for_step(action_name)
  end
  
  def wizard_profile_next_step(step)
    Wizard::Profile::STEPS[Wizard::Profile::STEPS.index(step) + 1]
  end
  
  def wizard_profile_for_step(step)
    raise InvalidStep unless step.in?(Wizard::Profile::STEPS)
    "Wizard::Profile::#{step.camelize}".constantize.new(session[:profile_attributes])
  end
  
  class InvalidStep < StandardError;
  end
end
