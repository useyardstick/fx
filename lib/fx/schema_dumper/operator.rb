require "rails"

module Fx
  module SchemaDumper
    # @api private
    module Operator
      def tables(stream)
        if Fx.configuration.dump_functions_at_beginning_of_schema
          operators(stream)
          empty_line(stream)
        end

        super

        unless Fx.configuration.dump_functions_at_beginning_of_schema
          operators(stream)
          empty_line(stream)
        end
      end

      def empty_line(stream)
        stream.puts if dumpable_operators_in_database.any?
      end

      def operators(stream)
        dumpable_operators_in_database.each do |operator|
          stream.puts(operator.to_schema)
        end
      end

      private

      def dumpable_operators_in_database
        @_dumpable_operators_in_database ||= Fx.database.operators
      end
    end
  end
end
