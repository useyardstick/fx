require "spec_helper"
require "fx/statements/operator"

describe Fx::Statements::Operator, :db do
  describe "#create_operator" do
    it "creates an operator" do
      database = stubbed_database

      connection.create_operator("&~&", "box", "box", function: "partially_overlaps")

      expect(database).to have_received(:create_operator).
        with("&~&", "box", "box", "partially_overlaps")
    end

    it "creates a unary operator" do
      database = stubbed_database

      connection.create_operator("&~", "box", function: "tiny_box")

      expect(database).to have_received(:create_operator).
        with("&~", nil, "box", "tiny_box")
    end
  end

  describe "#drop_operator" do
    it "drops the operator" do
      database = stubbed_database

      connection.drop_operator("&~&", "box", "box")

      expect(database).to have_received(:drop_operator).with("&~&", "box", "box")
    end

    it "drops the unary operator" do
      database = stubbed_database

      connection.drop_operator("&~", "box")

      expect(database).to have_received(:drop_operator).with("&~", nil, "box")
    end
  end

  def stubbed_database
    instance_spy("StubbedDatabase").tap do |stubbed_database|
      allow(Fx).to receive(:database).and_return(stubbed_database)
    end
  end
end
