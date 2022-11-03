require "spec_helper"

describe Fx::SchemaDumper::Operator, :db do
  it "dumps a create_operator for an operator in the database" do
    sql_definition = <<-EOS
      CREATE OR REPLACE FUNCTION partially_overlaps(a box,  b box) RETURNS boolean
        LANGUAGE SQL
        IMMUTABLE
        RETURN a && b AND NOT a <@ b AND NOT a @> b;
    EOS
    connection.create_function :partially_overlaps, sql_definition: sql_definition
    connection.create_operator "&~&", "box", "box", function: :partially_overlaps
    connection.create_table :my_table
    stream = StringIO.new
    output = stream.string

    ActiveRecord::SchemaDumper.dump(connection, stream)

    expect(output).to(
      match(/table "my_table".*create_operator "&~&", "box", "box", function: "partially_overlaps"/m),
    )
  end

  it "dumps a create_operator at beginning of schema" do
    begin
      Fx.configuration.dump_functions_at_beginning_of_schema = true

      sql_definition = <<-EOS
        CREATE OR REPLACE FUNCTION partially_overlaps(a box,  b box) RETURNS boolean
          LANGUAGE SQL
          IMMUTABLE
          RETURN a && b AND NOT a <@ b AND NOT a @> b;
      EOS
      connection.create_function :partially_overlaps, sql_definition: sql_definition
      connection.create_operator "&~&", "box", "box", function: :partially_overlaps
      connection.create_table :my_table
      stream = StringIO.new
      output = stream.string

      ActiveRecord::SchemaDumper.dump(connection, stream)

      expect(output).to(
        match(/create_operator "&~&", "box", "box", function: "partially_overlaps".*table "my_table"/m),
      )
    ensure
      Fx.configuration.dump_functions_at_beginning_of_schema = false
    end
  end
end
