require "spec_helper"

module Fx
  module Adapters
    describe Postgres::Operators, :db do
      describe ".all" do
        it "returns `Operator` objects" do
          connection = ActiveRecord::Base.connection
          connection.execute <<-EOS.strip_heredoc
            CREATE OR REPLACE FUNCTION partially_overlaps(a box,  b box) RETURNS boolean
              LANGUAGE SQL
              IMMUTABLE
              RETURN a && b AND NOT a <@ b AND NOT a @> b;

            CREATE OPERATOR &~& (
              LEFTARG = box,
              RIGHTARG = box,
              FUNCTION = partially_overlaps,
              COMMUTATOR = &~&
            );
          EOS

          operators = Postgres::Operators.new(connection).all

          first = operators.first
          expect(operators.size).to eq 1
          expect(first.name).to eq "&~&"
          expect(first.leftarg).to eq "box"
          expect(first.rightarg).to eq "box"
          expect(first.function).to eq "partially_overlaps"
          expect(first.commutator).to eq "&~&"
        end
      end
    end
  end
end
