defmodule AdventTest do
  use ExUnit.Case
  doctest Advent

  test "greets the world" do
    assert Advent.hello() == :world
  end

  describe "Day5" do
    alias Advent.Day5

    test "opposites destroy" do
      assert Day5.react('aA') == ''
      assert Day5.react('abBA') == ''
      assert Day5.react('abAB') == 'abAB'
      assert Day5.react('aabAAB') == 'aabAAB'
      assert Day5.react('dabAcCaCBAcCcaDA') == 'dabCBAcaDA'
    end
  end

  describe "Day6" do
    alias Advent.Day6
    setup do
      {:ok, input: ["1, 1", "1, 6", "8, 3", "3, 4", "5, 5", "8, 9"]}
    end

    test "parsing" do
      assert Day6.parse_line("12, 1") == %Day6.Input{x: 12, y: 1}
    end

    test "bounding_box", %{input: input} do
      assert Day6.parse_string_input(input) |> Day6.bounding_box() == {{0, 0}, {9, 10}}
    end

    test "nearest", %{input: i} do
      inputs = i
      |> Day6.parse_string_input()
      |> Enum.with_index()

      assert Day6.nearest(%Day6.GridCell{x: 2, y: 2, p: :interior}, inputs) == %{distance: 2, idx: 0}
    end

    test "nearest groups", %{input: i} do
      res = i
      |> Day6.make()
      |> Day6.set_nearest()
      |> Day6.nearest_groups()
      |> Day6.interior_groups()
      |> Map.to_list()
      |> Enum.map(fn {k, v} -> {k, length(v)} end)
      |> Enum.sort_by(fn {_, v} -> v end)
      |> Enum.reverse()
      |> hd()

      assert res == {4, 17}
    end
  end
end
