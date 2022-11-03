require "acceptance_helper"

describe "User manages operators" do
  it "handles binary operators" do
    successfully "rails generate fx:function partially_overlaps"
    write_function_definition "partially_overlaps_v01", <<-EOS
      CREATE OR REPLACE FUNCTION partially_overlaps(a box,  b box) RETURNS boolean
        LANGUAGE SQL
        IMMUTABLE
        RETURN a && b AND NOT a <@ b AND NOT a @> b;
    EOS
    successfully "rails generate fx:operator '&~&' 'box' 'box' --function partially_overlaps"
    successfully "rake db:migrate"

    result = execute("SELECT box '((0, 0), (3, 3))' &~& box '((2, 2), (4, 4))' AS result")
    expect(result).to eq("result" => true)

    result = execute("SELECT box '((0, 0), (3, 3))' &~& box '((1, 1), (2, 2))' AS result")
    expect(result).to eq("result" => false)

    successfully "rake db:rollback"
  end
end
