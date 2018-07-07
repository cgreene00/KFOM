class NewsletterMailer < ApplicationMailer
  default from: 'no-reply@kfom.org'
  
  def self.send_weekly_newsletter
    profiles = Profile.where("seller = ?", false)
    profiles.each do|p|
      if !p.user.email.nil?
        weekly_newsletter(p.user.email).deliver_now
      end
    end
  end
  
  def self.special_announcement
    users = User.all
    users.each do |u|
      if !u.email.blank?
        send_special_announcement(u.email).deliver_now
      end
    end
  end
  
  def send_special_announcement(email, subject)
    mail(to: email, subject: subject)
  end
  
  def weekly_newsletter(email)
    mail(to: email, subject: "Weekly newsletter")
  end
  
  def self.send_weekly_reminder_to_sellers
    profiles = Profile.where("seller = ?", true)
    profiles.each do |p|
      if !p.user.email.nil?
        weekly_reminder_to_sellers(p.user.email).deliver_now
      end
    end
  end
  
  def weekly_reminder_to_sellers(email)
    mail(to: email, subject: "Listing Reminder")
  end
end
