require "fx/schema_dumper/function"
require "fx/schema_dumper/trigger"
require "fx/schema_dumper/operator"

module Fx
  # @api private
  module SchemaDumper
    include Function
    include Trigger
    include Operator
  end
end
