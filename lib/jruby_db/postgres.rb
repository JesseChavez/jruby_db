# frozen_string_literal: true

module JRubyDB
  class Postgres < Abstract
    def self.connect(config)
      db_url = UrlConfig.new(:postgres, config).to_url

      new(db_url, config)
    end

    def initialize(connection_url, config)
      super

      load_driver

      setup_connection
    end

    def load_driver
      require "jdbc/postgres"
      Jdbc::Postgres.load_driver(:require) if defined?(::Jdbc::Postgres.load_driver)
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
      driver_name = "org.postgresql.Driver"

      # Utils.driver_class(driver_name, config[:driver])
      eval(driver_name)
    end
  end
end
