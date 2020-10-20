defmodule Hierarchy do
  @default_input "null,0,grandpa|0,1,son|0,2,daugther|1,3,grandkid|1,4,grandkid|2,5,grandkid|5,6,greatgrandkid"
  defstruct parent_id: nil, node_id: nil, node_name: ""

  # assume "null" string is key for root
  def compare(%Hierarchy{parent_id: "null"}, _), do: :lt  # make "null" lowest value, first in sorted list
  def compare(_, _), do: :eq

  def split_nodes(input \\ @default_input) do
    input
    |> String.split("|")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn [pID, nID, name] -> %Hierarchy{parent_id: pID, node_id: nID, node_name: name} end)
    |> Enum.sort(Hierarchy)
  end

  def extract_children(list, parent) do
    Enum.split_with(list, fn %Hierarchy{parent_id: pID} -> pID == parent.node_id end)
  end

  def create_hierarchy(list, level \\ 0) do
    [parent | tail] = list
    IO.puts "#{String.duplicate("-", level)}#{parent.node_name}, ID: #{parent.node_id}"
    {children, rest} = Hierarchy.extract_children(tail, parent)
    Enum.each(children, &Hierarchy.create_hierarchy([&1 | rest], level + 1))
  end
end

Hierarchy.split_nodes() |> Hierarchy.create_hierarchy()

# possible improvements:
# orphaned children
# circular hierarchy detection
# multiple roots
# multiple parents
