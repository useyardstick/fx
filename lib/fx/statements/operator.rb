require "rails"

module Fx
  module Statements
    # Methods that are made available in migrations for managing Fx operators.
    module Operator
      # Create a new database operator.
      #
      # @param name [String, Symbol] The name of the database operator.
      # @param leftarg [String, Symbol] The type of the left operand (optional).
      # @param rightarg [String, Symbol] The type of the right operand (required).
      # @param function [String, Symbol] The name of the function to use for the operator.
      # @return The database response from executing the create statement.
      #
      # @example Create operator
      #   create_operator("&&&&", :geometry, :geometry, function: "ST_Overlaps")
      #
      def create_operator(name, *args, **options)
        leftarg, rightarg = operand_types(args)
        Fx.database.create_operator(name, leftarg, rightarg, options)
      end

      # Drop a database operator by name and operand types.
      #
      # @param name [String, Symbol] The name of the database operator.
      # @param leftarg [String, Symbol] The type of the left operand (optional).
      # @param rightarg [String, Symbol] The type of the right operand (required).
      # @return The database response from executing the drop statement.
      #
      # @example Drop an operator, rolling back to version 2 on rollback
      #   drop_operator("&&&&", :geometry, :geometry)
      #
      def drop_operator(name, *args)
        leftarg, rightarg = operand_types(args)
        Fx.database.drop_operator(name, leftarg, rightarg)
      end

      private

      def operand_types(args)
        case args.size
        when 1
          [nil, args.first]
        when 2
          args
        else
          raise ArgumentError, "must have 1 or 2 operands"
        end
      end
    end
  end
end
