require 'bundler'
Bundler.require


module Cronify
  
    
  ENV_KEYS = %w(GEM_HOME GEM_PATH PATH)
  @@filepath ||= "cron.job" 

  def self.cron_tasks
    tasks = `crontab -l`
    tasks.include?("crontab:no crontab for") ? nil : tasks
  end
  

  def self.push(group_name, &block)
    File.open('cron.job','w') do |file|

      file.write cron_tasks if cron_tasks
      file.write "## #{group_name} #{'#'*200}\n"

      ENV_KEYS.each do |key|
        file.write "#{key}=#{ENV[key]}\n" if ENV[key]
      end

      tasks = []
      yield tasks
      tasks.each do |task|
        file.write "#{task}\n"
      end

      file.write "## end #{group_name} #{'#'*200}\n"
    end

    update_cron
  end


  def self.pop(group_name)
    cron = self.cron_tasks.gsub(/## #{group_name}.*## end #{group_name} #*\n/m,'')
    File.open('cron.job','w').write cron
    update_cron
  end


  def self.update_cron
    `crontab cron.job`
  end

end
