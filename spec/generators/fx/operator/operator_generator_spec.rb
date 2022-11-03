require "spec_helper"
require "generators/fx/operator/operator_generator"

describe Fx::Generators::OperatorGenerator, :generator do
  it "creates a migration" do
    migration = file("db/migrate/create_operator_partially_overlaps.rb")

    run_generator ["&~&", "box", "box", "--function=partially_overlaps"]

    expect(migration).to be_a_migration
    expect(migration_file(migration)).to contain "CreateOperatorPartiallyOverlaps"
  end
end
