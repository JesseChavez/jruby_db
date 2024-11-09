# frozen_string_literal: true

module JRubyDB
  module Utils
    def self.driver_class(driver, driver_override)
      driver_name = driver_string(driver, driver_override)

      class_string = driver_constant_string(driver_name)

      unless Object.const_defined?(class_string)
        # java driver was not loaded properly
        raise "Undefined constant: #{class_string}"
      end

      Object.const_get(class_string)
    end

    def self.driver_string(driver, driver_override)
      override = driver_override.to_s.strip

      return override unless override.empty?

      driver
    end

    def self.driver_constant_string(driver_name)
      driver_parts = driver_name.split(".")

      main_class = driver_parts.pop

      "Java::#{driver_parts.map(&:capitalize).join}::#{main_class}"
    end
  end
end
