module Fx
  # @api private
  class Operator
    include Comparable

    attr_reader :name, :leftarg, :rightarg, :function
    delegate :<=>, to: :name

    def initialize(operator_row)
      @name = operator_row.fetch("name")
      @leftarg = operator_row.fetch("leftarg")
      @rightarg = operator_row.fetch("rightarg")
      @function = operator_row.fetch("function")
    end

    def ==(other)
      name == other.name && leftarg == other.leftarg && rightarg == other.rightarg
    end

    def to_schema
      args = [leftarg, rightarg].compact.map { |arg| "\"#{arg}\"" }.join(", ")
      <<-SCHEMA
  create_operator "#{name}", #{args}, function: "#{function}"
      SCHEMA
    end
  end
end
