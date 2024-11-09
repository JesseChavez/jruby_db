# frozen_string_literal: true

module JRubyDB
  class SQLite3 < Abstract
    def self.connect(config)
      db_url = UrlConfig.new(:sqlite, config).to_url

      new(db_url, config)
    end

    def initialize(connection_url, config)
      super

      load_driver

      setup_connection
    end

    def raw_execute(sql)
      stmt = connection.createStatement

      result_set = stmt.execute_query(sql)

      result = []

      columns = result_set.column_count

      while result_set.next
        result << result_range(columns).map { |index| result_set.get_object(index) }
      end

      stmt.close

      result
    end

    def load_driver
      require "jdbc/sqlite3"
      Jdbc::SQLite3.load_driver(:require) if defined?(::Jdbc::SQLite3.load_driver)
    rescue LoadError
      # assuming driver.jar is on the class-path
    end

    def setup_connection
      @driver = driver_class.new

      props = java.util.Properties.new

      @connection = @driver.connect(connection_url, props)

      # TODO: handle Exceptions
    end

    def driver_class
      driver_name = "org.sqlite.JDBC"

      # Utils.driver_class(driver_name, config[:driver])
      eval(driver_name)
    end
  end
end
