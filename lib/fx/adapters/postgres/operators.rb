require "fx/function"

module Fx
  module Adapters
    class Postgres
      # Fetches defined operators from the postgres connection.
      # @api private
      class Operators
        # The SQL query used by F(x) to retrieve the operators considered
        # dumpable into `db/schema.rb`.
        OPERATORS_QUERY = <<-EOS.freeze
          SELECT
            pg_operator.oprname AS name,
            leftarg.typname AS leftarg,
            rightarg.typname AS rightarg,
            pg_operator.oprcode AS function,
            commutator.oprname AS commutator,
            negator.oprname AS negator,
            pg_operator.oprrest AS restrict,
            pg_operator.oprjoin AS join,
            pg_operator.oprcanhash AS hashes,
            pg_operator.oprcanmerge AS merges
          FROM pg_operator
          LEFT JOIN pg_type AS leftarg
            ON pg_operator.oprleft = leftarg.oid
          INNER JOIN pg_type AS rightarg
            ON pg_operator.oprright = rightarg.oid
          INNER JOIN pg_namespace
            ON pg_operator.oprnamespace = pg_namespace.oid
          LEFT JOIN pg_depend
            ON pg_operator.oid = pg_depend.objid AND pg_depend.deptype = 'e'
          LEFT JOIN pg_operator AS commutator
            ON pg_operator.oprcom = commutator.oid
          LEFT JOIN pg_operator AS negator
            ON pg_operator.oprnegate = negator.oid
          WHERE pg_namespace.nspname = 'public' AND pg_depend.objid IS NULL
        EOS

        # Wraps #all as a static facade.
        #
        # @return [Array<Fx::Operator>]
        def self.all(*args)
          new(*args).all
        end

        def initialize(connection)
          @connection = connection
        end

        # All of the operators that this connection has defined.
        #
        # @return [Array<Fx::Operator>]
        def all
          operators_from_postgres.map { |operator| to_fx_operator(operator) }
        end

        private

        attr_reader :connection

        def operators_from_postgres
          connection.execute(OPERATORS_QUERY)
        end

        def to_fx_operator(result)
          Fx::Operator.new(result)
        end
      end
    end
  end
end
