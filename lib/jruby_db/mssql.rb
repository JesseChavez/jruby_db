# frozen_string_literal: true

module JRubyDB
  class Mssql < Abstract
    def self.connect(config)
      db_url = UrlConfig.new(:mssql, config).to_url

      new(db_url, config)
    end

    def initialize(connection_url, config)
      super

      load_driver

      setup_connection
    end

    def load_driver
      require "jdbc/mssql"
      Jdbc::Mssql.load_driver(:require) if defined?(::Jdbc::Mysql.load_driver)
    rescue LoadError
      # assuming driver.jar is on the class-path
    end

    def setup_connection
      @driver = driver_class.new

      props = java.util.Properties.new

      props.setProperty("user", config[:username])
      props.setProperty("password", config[:password])

      @connection = @driver.connect(connection_url, props)

      # TODO: handle Exceptions
    end

    def driver_class
      driver_name = "com.microsoft.sqlserver.jdbc.SQLServerDriver"

      # Utils.driver_class(driver_name, config[:driver])
      eval(driver_name)
    end
  end
end
