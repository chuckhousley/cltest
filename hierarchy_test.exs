ExUnit.start()

defmodule HierarchyTest do
  use ExUnit.Case

  test "split_nodes returns list of Hierarchy nodes" do
    expected = [
      %Hierarchy{parent_id: "null", node_id: "0", node_name: "grandpa"},
      %Hierarchy{parent_id: "0", node_id: "1", node_name: "son"},
    ]
    assert Hierarchy.split_nodes("null,0,grandpa|0,1,son") == expected
  end

  test "extract_children returns lists of children and non-children" do
    parent = %Hierarchy{parent_id: "null", node_id: "0", node_name: "grandpa"}
    input = [
        %Hierarchy{parent_id: "0", node_id: "1", node_name: "son"},
        %Hierarchy{parent_id: "0", node_id: "2", node_name: "daughter"},
        %Hierarchy{parent_id: "1", node_id: "3", node_name: "grandson"},
        %Hierarchy{parent_id: "2", node_id: "4", node_name: "granddaughter"},
    ]
    expected = {
      [
        %Hierarchy{parent_id: "0", node_id: "1", node_name: "son"},
        %Hierarchy{parent_id: "0", node_id: "2", node_name: "daughter"},
      ],
      [
        %Hierarchy{parent_id: "1", node_id: "3", node_name: "grandson"},
        %Hierarchy{parent_id: "2", node_id: "4", node_name: "granddaughter"},
      ]
    }
    assert Hierarchy.extract_children(input, parent) == expected
  end
end
