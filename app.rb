require 'toml'
require 'sequel'
require 'guillotine'

module Parkr
  class Db
    attr_accessor :username, :host, :port, :db_name

    def initialize(file = "mysql2.toml")
      config_file = File.expand_path(file)
      configs = TOML.load_file(config_file)
      self.username = configs["username"]
      self.host     = configs["host"]
      self.port     = configs["port"]
      self.db_name  = configs["db_name"]
    end

    def sequel_connection
      Sequel.connect("mysql2://#{username}@#{host}:#{port}/#{db_name}")
    end
  end

  class App < Guillotine::App
    db = Parkr::Db.new.sequel_connection
    adapter = Guillotine::Adapters::SequelAdapter.new(db)
    set :service => Guillotine::Service.new(adapter)

    get '/' do
      redirect 'http://parkermoo.re'
    end
  end
end
