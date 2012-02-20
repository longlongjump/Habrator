require 'twitter'

module SpamNotification

  Twitter.configure do |config|
    config.consumer_key = "hWk6je3xcT0PjmOh140wH"
    config.consumer_secret = "8Rdpbq6jP2yu9kcbP6LuOnbDJuQRBnF1iBBzFtE"
    config.oauth_token = "49221892_858rZDvzDuzR83DHDyjsiEhS-ixmxsV7zJoxVc83"
    config.oauth_token_secret = "SMj4TNIspLDmrCOvrjiWFW11wQ2hJ53yuHD8bXja3Q"
  end
  
  def self.notificate_new_post(post)
    tweet = "#{post[:title]} #{post[:url]}"
    Twitter.update(tweet)  
  end


end

