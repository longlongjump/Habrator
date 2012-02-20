require 'twitter'

module SpamNotification

  Twitter.configure do |config|
    config.consumer_key = YOUR_CONSUMER_KEY
    config.consumer_secret = YOUR_CONSUMER_SECRET
    config.oauth_token = YOUR_OAUTH_TOKEN
    config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET 
  end
  
  def self.notificate_new_post(post)
    begin
      tweet = "#{post[:title]} #{post[:url]}"
      Twitter.update(tweet)  
    rescue Exception => e
      puts e
    end
  end

end
