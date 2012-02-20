require "rubygems"
require "json"
require "sequel"

class Habrator

  def initialize
    @db = Sequel.sqlite('posts.db')
  end

  def call(env)
    path = env['REQUEST_PATH']

    case path
    when "/posts"
      p = @db[:posts].order(:id.desc)
      [200, {'Content-Type'=>'application/json'}, StringIO.new(JSON(p.all))]
    else
      Rack::File.new('static/index.html').call(env)
    end

  end
end

use Rack::Static, :urls => ["/static"]


run Habrator.new
