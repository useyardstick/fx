require "rails"
require "fx/statements/function"
require "fx/statements/trigger"
require "fx/statements/operator"

module Fx
  # @api private
  module Statements
    include Function
    include Trigger
    include Operator
  end
end
