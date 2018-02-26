require 'date'

#tasks

task :weekly_newsletter => :environment do
  if Time.now.monday?
    NewsletterMailer::send_weekly_newsletter
  end
end

task :weekly_reminder => :environment do
  if Time.now.friday?
    NewsletterMailer::send_weekly_reminder_to_sellers
  end
end

task :buyer_reminder => :environment do
  if Time.now.wednesday?
    OrderMailer::cancelled_orders
    OrderMailer::buyer_reminder
  end
end

task :seller_reminder => :environment do
  if Time.now.wednesday?
    OrderMailer::seller_reminder
  end
end

task :clean_listings => :environment do
  if Time.now.wednesday?
    Post::deactivate_listings
    Week::add_week
    Profile.sellers.update_all(order_total: '0')
  end
end

task :all_reminders => :environment do
  if Time.now.wednesday?
    OrderMailer::cancelled_orders
    OrderMailer.weekly_order_summary.deliver_now
    OrderMailer::buyer_reminder
    OrderMailer::seller_reminder
    Post::deactivate_listings
    OrderMailer.weekly_seller_summary.deliver_now
    Week::add_week
    Profile.sellers.update_all(order_total: '0')
  end
end
