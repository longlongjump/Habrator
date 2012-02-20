require 'sequel'
require 'open-uri'
require 'nokogiri'
require './twitter_notification'

desc "Create Posts database"
file "posts.db" do
  db = Sequel.sqlite('posts.db')
  db.create_table :posts do
    primary_key :id
    String :title
    String :url
  end
end

def habr_posts
  user_agent = {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11"}
  html = open('http://habrahabr.ru/', user_agent).read
  doc = Nokogiri::HTML(html)

  doc.search('div[@class=post]').map do |el|
    title_el = el.search('a[@class=post_title]').first
    {
      :id => el.attr('id').match(/\d+/)[0],
      :title => title_el.text,      
      :url => title_el.attr('href')
    }
  end

end

desc "Update posts"
task :update_posts => 'posts.db' do
  post_set = Sequel.sqlite('posts.db')[:posts]
  posts = habr_posts
  new_post = nil
  posts.each do |post|
    begin
      post_set.insert(post)
      new_post ||= post
    rescue Exception => e
      puts e
    end
  end
  SpamNotification::notificate_new_post new_post if new_post
end


desc "Create cron job"
file 'cron.job' do
  dir = File.expand_path(File.dirname(__FILE__))
  bundler_path = `which bundle`
  File.open('cron.job','a') do |file|
    file.write "#{`crontab -l`}\n" 
    file.write "* * * * * cd #{dir} && #{bundler_path[0..-2]} exec rake update_posts"
  end
  sh %{crontab cron.job}
end


task :default => ["post.db"]

