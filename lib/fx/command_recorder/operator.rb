module Fx
  module CommandRecorder
    # @api private
    module Operator
      def create_operator(*args)
        record(:create_operator, args)
      end

      def drop_operator(*args)
        record(:drop_operator, args)
      end

      def invert_create_operator(args)
        args.pop # remove "function" option
        [:drop_operator, args]
      end
    end
  end
end
