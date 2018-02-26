class UserMailer < ApplicationMailer

  default from: 'no-reply@kfom.org'
  
  def welcome(user)
    @profile = user.profile
    mail( to: user.email, subject: "Welcome to Klamath Food Buyers Club" )
  end

end
