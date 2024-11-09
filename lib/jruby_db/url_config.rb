# frozen_string_literal: true

module JRubyDB
  class UrlConfig
    attr_reader :database
    attr_reader :config

    def initialize(database, config)
      @database = database
      @config   = config
    end

    def to_url
      case database
      when :sqlite
        sqlite_url
      when :postgres
        postgres_url
      when :mysql
        mysql_url
      when :mssql
        mssql_url
      end
    end

    def sqlite_url
      database = config[:database]

      "jdbc:sqlite:#{database}"
    end

    def postgres_url
      database = config[:database]

      db_host     = config[:host] || "localhost"
      db_port     = config[:port] || 5432

      "jdbc:postgresql://#{db_host}:#{db_port}/#{database}"
    end

    def mysql_url
      database = config[:database]

      db_host     = config[:host] || "localhost"
      db_port     = config[:port] || 3306

      "jdbc:mysql://#{db_host}:#{db_port}/#{database}"
    end

    def mssql_url
      database = config[:database]

      db_host     = config[:host] || "localhost"
      db_port     = config[:port] || 1433

      "jdbc:sqlserver://#{db_host}:#{db_port};database=#{database};trustServerCertificate=true"
    end
  end
end
