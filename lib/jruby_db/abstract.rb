# frozen_string_literal: true

module JRubyDB
  class Abstract
    attr_reader :connection
    attr_reader :connection_url
    attr_reader :config

    def initialize(connection_url, config)
      @connection_url = connection_url
      @config         = config
    end

    def execute(sql, binds = [], &block)
      prepare(sql) do |stmt|
        binds.each.with_index(1) { |bind, index| stmt.set_string(index, bind) }

        result_set = stmt.execute_query

        meta_data = result_set.meta_data
        col_count = meta_data.column_count

        if block
          while result_set.next
            row = result_row(result_set, col_count)
            yield row
          end
        else
          result = []

          while result_set.next
            row = result_row(result_set, col_count)
            result << row
          end

          result.freeze
        end
      end
    end

    def prepare(sql)
      stmt = connection.prepare_statement(sql)

      return stmt unless block_given?

      begin
        yield stmt
      ensure
        stmt.close unless stmt.closed?
      end
    end

    def result_row(result_set, column_count)
      (1..column_count).map { |col| result_set.get_object(col) }
    end

    def close
      @connection.close
    end
  end
end
