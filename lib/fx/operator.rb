module Fx
  # @api private
  class Operator
    include Comparable

    attr_reader :name, :leftarg, :rightarg, :function

    # Optimization params for the query planner:
    attr_reader :commutator, :negator, :restrict, :join, :hashes, :merges

    delegate :<=>, to: :name

    def initialize(operator_row)
      @name = operator_row.fetch("name")
      @leftarg = operator_row.fetch("leftarg")
      @rightarg = operator_row.fetch("rightarg")
      @function = operator_row.fetch("function")
      @commutator = operator_row.fetch("commutator")
      @negator = operator_row.fetch("negator")
      @restrict = operator_row.fetch("restrict")
      @join = operator_row.fetch("join")
      @hashes = operator_row.fetch("hashes")
      @merges = operator_row.fetch("merges")
    end

    def ==(other)
      name == other.name && leftarg == other.leftarg && rightarg == other.rightarg
    end

    def to_schema
      args = [leftarg, rightarg]
        .compact
        .map { |arg| "\"#{arg}\"" }
        .join(", ")

      options = [:function, :commutator, :negator, :restrict, :join, :hashes, :merges]
        .to_h { |option| [option, send(option)] }
        .compact
        .map { |key, value| "#{key}: \"#{value}\"" }
        .join(", ")

      <<-SCHEMA
  create_operator "#{name}", #{args}, #{options}
      SCHEMA
    end
  end
end
