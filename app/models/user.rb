class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, :omniauth_providers => [:facebook, :google]
  has_many :identities, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one :profile, dependent: :destroy
  
  def facebook
    identities.where( :provider => 'facebook' ).first
  end
  
  def facebook_client
    @facebook_client ||= Facebook.client( access_token: facebook.accesstoken)
  end
  
  def google_oauth2
    identities.where( :provider => 'google_oauth2' ).first
  end
  
  def google_oauth2_client
    if !@google_oauth2_client
      @google_oauth2_client = Google::APIClient.new( :application_name => 'HappySeed App', :application_version => '1.0.0')
      @google.oauth2_client.authorization.udpate_token!({ :access_token => google_oauth2.accesstoken, :refresh_token => google_oauth2.refreshtoken })
    end
    @google_oauth2_client
  end
         
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

end
