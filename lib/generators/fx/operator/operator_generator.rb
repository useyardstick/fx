require "rails/generators"
require "rails/generators/active_record"

module Fx
  module Generators
    # @api private
    class OperatorGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("../templates", __FILE__)
      argument :name, type: :string, required: true
      argument :firstarg, type: :string, required: true
      argument :secondarg, type: :string, required: false
      class_option :function, type: :string, required: true

      def create_migration_file
        migration_template(
          "db/migrate/create_operator.erb",
          "db/migrate/create_operator_#{function_name}.rb",
        )
      end

      def self.next_migration_number(dir)
        ::ActiveRecord::Generators::Base.next_migration_number(dir)
      end

      no_tasks do
        def activerecord_migration_class
          if ActiveRecord::Migration.respond_to?(:current_version)
            "ActiveRecord::Migration[#{ActiveRecord::Migration.current_version}]"
          else
            "ActiveRecord::Migration"
          end
        end

        def leftarg
          secondarg ? firstarg : nil
        end

        def rightarg
          secondarg || firstarg
        end

        def formatted_args
          [leftarg, rightarg].compact.map { |arg| "\"#{arg}\"" }.join(", ")
        end

        def function_name
          options.fetch(:function)
        end
      end
    end
  end
end
