defmodule Advent do
  @moduledoc """
  Documentation for Advent.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Advent.hello()
      :world

  """
  def hello do
    :world
  end

  def read_file(id) do
    {:ok, s} = Path.expand("./inputs/#{id}.txt")
    |> IO.inspect(label: "file path")
    |> File.read()
    String.split(s, "\n")
  end

  defmodule Day5 do
    @spec react(charlist()) :: [any()]
    def react(s) do
      Enum.reduce(s, [], &react/2)
      |> Enum.reverse()
    end

    def react(char, acc) do
      case acc do
        [] ->
          [char]
        [h | t] when h + 32 === char or h - 32 === char ->
          t
        [_h | _] ->
          [char | acc]
        n when is_integer(n) ->
          [n | acc]
      end
    end

    def remove_pair(charlist, lower) do
      upper = lower - 32
      Enum.reject(charlist, &(&1 == upper or &1 == lower))
    end

    def part1() do
      Advent.read_file(5)
      |> List.first()
      |> to_charlist()
      |> react()
      |> length()
    end

    def part2() do
      s = Advent.read_file(5) |> List.first() |> to_charlist()
      Enum.map(?a..?z, fn x ->
        remove_pair(s, x) |> react() |> length()
      end)
      |> Enum.sort()
    end
  end
end
