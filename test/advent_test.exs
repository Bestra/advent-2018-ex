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
    input = ["1, 1", "1, 6", "8, 3", "3, 4", "5, 5", "8, 9"]

    test "parsing" do
      assert Day6.parse_line("12, 1") == {12, 1}
    end

    test "bounding_box" do
      input = ["1, 1", "1, 6", "8, 3", "3, 4", "5, 5", "8, 9"]

      assert Day6.inputs(input) |> Day6.bounding_box() == {{0, 0}, {9, 10}}
    end

    test "nearest" do
      i = ["1, 1", "1, 6", "8, 3", "3, 4", "5, 5", "8, 9"]
      |> Day6.inputs()
      |> Enum.with_index()

      assert Day6.nearest({2, 2}, i) == {2, 0}
    end
  end
end
