defmodule AdventTest do
  use ExUnit.Case
  doctest Advent

  test "greets the world" do
    assert Advent.hello() == :world
  end

  describe "Day5" do
    alias Advent.Day5
    test "opposites destroy" do
      assert Day5.react("aA") == ""
      assert Day5.react("abBA") == ""
      assert Day5.react("abAB") == "abAB"
      assert Day5.react("aabAAB") == "aabAAB"
      assert Day5.react("dabAcCaCBAcCcaDA") == "dabCBAcaDA"
    end
  end
end
