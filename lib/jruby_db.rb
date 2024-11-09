# frozen_string_literal: true

require_relative "jruby_db/version"
require_relative "jruby_db/url_config"
require_relative "jruby_db/utils"

require_relative "jruby_db/abstract"
require_relative "jruby_db/sqlite3"
require_relative "jruby_db/postgres"
require_relative "jruby_db/mysql"
require_relative "jruby_db/mssql"

module JRubyDB
  class Error < StandardError
  end

  DB_SERVERS = %w[sqlite3 postgres mysql mssql].freeze

  def self.connect(db_server, config = {})
    raise "Unknown database server" unless DB_SERVERS.include?(db_server)

    setup_connection(db_server, config)
  end

  def self.setup_connection(db_server, config)
    case db_server
    when "sqlite3"
      sqlite3_connect(config)
    when "postgres"
      postgres_connect(config)
    when "mysql"
      mysql_connect(config)
    when "mssql"
      mssql_connect(config)
    end
  end

  def self.sqlite3_connect(config)
    SQLite3.connect(config)
  end

  def self.postgres_connect(config)
    Postgres.connect(config)
  end

  def self.mysql_connect(config)
    Mysql.connect(config)
  end

  def self.mssql_connect(config)
    Mssql.connect(config)
  end
end
