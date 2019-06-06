module CalculateAll
  module Helpers
    module_function
    # Method to convert function aliases like :count to SQL commands like 'COUNT(*)'
    def decode_function_aliases(aliases)
      aliases.map do |key|
        function =
          case key
          when String
            key
          when :count
            'COALESCE(COUNT(*), 0)'
          when /^(.*)_distinct_count$/, /^count_distinct_(.*)$/
            "COALESCE(COUNT(DISTINCT #{$1}), 0)"
          when /^(.*)_(count|sum|max|min|avg)$/
            "COALESCE(#{$2.upcase}(#{$1}), 0)"
          when /^(count|sum|max|min|avg)_(.*)$$/
            "COALESCE(#{$1.upcase}(#{$2}), 0)"
          when /^(.*)_average$/, /^average_(.*)$/
            "COALESCE(AVG(#{$1}), 0)"
          when /^(.*)_maximum$/, /^maximum_(.*)$/
            "COALESCE(MAX(#{$1}), 0)"
          when /^(.*)_minimum$/, /^minimum_(.*)$/
            "COALESCE(MIN(#{$1}), 0)"
          else
            raise ArgumentError, "Can't recognize function alias #{key}"
          end
        [key, function]
      end.to_h
    end
  end
end
