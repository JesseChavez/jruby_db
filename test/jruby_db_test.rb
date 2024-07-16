# frozen_string_literal: true

require "test_helper"

class JrubyDbTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::JRubyDB.const_defined?(:VERSION)
    end
  end

  test "something useful" do
    assert_equal("expected", "actual")
  end
end
