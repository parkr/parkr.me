require 'toml'
require 'sequel'
require 'mysql2'
require 'guillotine'

module Parkr
  class Db
    attr_accessor :username, :host, :port, :db_name, :password

    def initialize(file = "db.toml")
      config_file = File.expand_path(file)
      configs = TOML.load_file(config_file)
      self.username = configs["username"] || 'root'
      self.password = configs["password"] || nil
      self.host     = configs["host"]     || '127.0.0.1'
      self.port     = configs["port"]     || '3306'
      self.db_name  = configs["db_name"]  || 'guillotine'
    end

    def login
      info = username.dup
      info << ":#{password}" if password
      info
    end

    def connection
      @connection ||= Sequel.connect("mysql2://#{login}@#{host}:#{port}/#{db_name}")
    end
    
    def setup
      connection.run <<-EOS
CREATE TABLE IF NOT EXISTS `urls` (
  `url` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  UNIQUE KEY `url` (`url`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
      EOS
    end
  end

  class App < Guillotine::App
    db = Parkr::Db.new.connection
    adapter = Guillotine::Adapters::SequelAdapter.new(db)
    set :service => Guillotine::Service.new(adapter)

    get '/' do
      redirect 'http://parkermoo.re'
    end
  end
end
